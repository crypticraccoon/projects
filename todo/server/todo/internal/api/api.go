package api

import (
	"context"
	"errors"
	"net/http"
	"server/internal/database"
	"server/internal/middlewares"
	"server/internal/response"

	"github.com/go-chi/chi/v5"
	"go.opentelemetry.io/contrib/instrumentation/net/http/otelhttp"
)

type Api struct {
	context  context.Context
	database *database.Database
	router   *chi.Mux
}

func New(ctx context.Context, db *database.Database, router *chi.Mux) *Api {
	return &Api{
		context:  ctx,
		database: db,
		router:   router,
	}
}

func (a *Api) InitApi() {

	a.router.Get("/.well-known/assetlinks.json", a.serveAssetLinks)

	a.router.Route("/v1", func(r chi.Router) {
		a.router.Get("/hello", func(w http.ResponseWriter, r *http.Request) {
			response.WithJson(w, "Hello world.")
		})
		r.Use(otelhttp.NewMiddleware(""))

		r.Get("/broken", func(w http.ResponseWriter, r *http.Request) {
			//response.WithJson(w, "Hello world.")
			response.WithError(w, 400, "broken", errors.New("broken"))
		})

		r.Post("/login", a.login)
		r.Post("/refresh", a.refresh)
		r.Post("/logout", a.logout)

		r.Route("/register", func(r chi.Router) {
			r.Post("/", a.register)
			r.Get("/verify/{id}/{code}", a.verifyRegistrationEmail)
			r.Put("/new/{id}/{code}", a.addUserData)
		})

		r.Route("/recover", func(r chi.Router) {
			r.Post("/", a.sendRecoveryEmail)
			r.Get("/verify/{email}/{code}", a.verifyRecoveryEmail)
			r.Put("/update/{email}/{code}", a.updateRecoverPassowrd)
		})

		authRouter := chi.NewRouter()
		r.Mount("/a", authRouter)
		authRouter.With(middlewares.AuthMiddleware).Route("/", func(r chi.Router) {
			r.Route("/todo", func(r chi.Router) {
				r.Post("/create", a.createTodo)
				r.Get("/{id}", a.getTodo)
				r.Get("/{date}/{size}/{page}", a.getTodosByDate) // NOTE: yyyy-mm-dd
				r.Get("/completed/{size}/{page}", a.getCompletedTodos)
				r.Patch("/complete/{id}", a.completeTodo)
				r.Get("/stats", a.getTodoStats)
				r.Put("/update", a.updateTodo)
				r.Delete("/delete/{id}", a.deleteTodo)
			})

			r.Route("/user", func(r chi.Router) {
				r.Get("/", a.getUserData)
				r.Route("/update", func(r chi.Router) {
					r.Patch("/username", a.updateUsername)
					r.Patch("/password", a.updatePassword)
					r.Patch("/email", a.updateEmail)
				})
			})
		})
	})

}
