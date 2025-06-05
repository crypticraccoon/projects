package server

import (
	"context"
	"log"
	"net/http"
	"os"
	"os/signal"
	"server/internal/api"
	"server/internal/confs"
	"server/internal/database"
	"syscall"
	"time"

	"github.com/go-chi/chi/v5"
	"github.com/go-chi/chi/v5/middleware"
	"github.com/go-chi/cors"
	"github.com/go-chi/httprate"
)

type Server struct {
	context  context.Context
	router   *chi.Mux
	database *database.Database
	config   *confs.Server
}

func New(ctx context.Context, config *confs.Server) *Server {
	return &Server{
		context: ctx,
		router:  chi.NewMux(),
		config:  config,
	}
}

func (s *Server) Init() error {
	corsConfig := confs.InitCorsConfig()

	s.initGlobalMiddlewares(corsConfig)

	dbConfig, err := confs.InitDatabaseConfig(s.context)
	if err != nil {
		return err
	}

	if err := s.initDatabase(dbConfig); err != nil {
		return err
	}

	s.initApi()

	return nil
}

func (s *Server) initGlobalMiddlewares(corsConfig *confs.Cors) {
	allowedCharsets := []string{"UTF-8", ""}
	s.router.Use(middleware.RealIP)
	s.router.Use(middleware.ContentCharset(allowedCharsets...))
	s.router.Use(middleware.AllowContentType("application/json"))
	s.router.Use(middleware.CleanPath)

	s.router.Use(cors.Handler(cors.Options{
		AllowedOrigins:   corsConfig.AllowedHeaders,
		AllowedMethods:   corsConfig.AllowedMethods,
		AllowedHeaders:   corsConfig.AllowedHeaders,
		AllowCredentials: corsConfig.AllowCredentials,
		MaxAge:           corsConfig.MaxAge,
	}))
	s.router.Use(middleware.Heartbeat("/health"))
	s.router.Use(middleware.Recoverer)
	s.router.Use(httprate.LimitByIP(100, 1*time.Minute))
}

func (s *Server) initDatabase(dbConfig *confs.Database) error {

	db := database.NewDatabase(s.context)
	err := db.Connect(dbConfig)
	if err != nil {
		return err
	}
	s.database = db

	return nil
}

func (s *Server) initApi() {
	endpoints := api.New(s.context, s.database, s.router)
	endpoints.InitApi()
}

func (s *Server) Start() {
	server := &http.Server{Addr: s.config.GetAddress(), Handler: s.router}

	serverCtx, serverStopCtx := context.WithCancel(s.context)

	sig := make(chan os.Signal, 1)
	signal.Notify(sig, syscall.SIGHUP, syscall.SIGINT, syscall.SIGTERM, syscall.SIGQUIT, syscall.SIGABRT, syscall.SIGKILL, syscall.SIGTERM)

	go func() {
		<-sig
		shutdownCtx, _ := context.WithTimeout(serverCtx, time.Duration(s.config.ShutdownTimeout*int(time.Second)))

		go func() {
			<-shutdownCtx.Done()
			if shutdownCtx.Err() == context.DeadlineExceeded {
				println("Failed to gracefully shutdown server...forcing exit.")
			} else {
				println("Server gracefully shutdown.")
			}
		}()

		if err := server.Shutdown(shutdownCtx); err != nil {
			log.Fatal(err)
		}

		defer s.database.Close()

		serverStopCtx()
	}()

	err := server.ListenAndServe()
	if err != nil && err != http.ErrServerClosed {
		log.Fatal(err)
	}

	<-serverCtx.Done()
}
