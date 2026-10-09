package main

import (
	"fmt"
	"log"
	"net/http"
	"os"
	"ps_image/internal/api"
	"time"

	"github.com/go-chi/chi/v5"
	"github.com/go-chi/chi/v5/middleware"
	"github.com/go-chi/cors"
	"github.com/joho/godotenv"
)

func main() {
	APP_ENV := os.Getenv("APP_ENV")
	if APP_ENV == "production" {
		err := godotenv.Load(".env.production")
		if err != nil {
			log.Fatal("Error loading .env file")
		}
	} else {
		err := godotenv.Load(".env.local")
		if err != nil {
			log.Fatal("Error loading .env file")
		}
	}

	r := chi.NewRouter()
	r.Use(middleware.Timeout(5 * time.Minute))

	r.Use(cors.Handler(cors.Options{
		AllowedOrigins: []string{"http://*"},
	}))
	r.Use(middleware.Logger)

	r.Get("/calendar", api.GetDates)

	r.Route("/image", func(r chi.Router) {
		r.Post("/", api.GetImage)
		r.Post("/thumbnail", api.GetThumbnail)
		r.Post("/count", api.GetBorderCount)
		r.Post("/extract", api.ExtractPhotos)
	})

	r.Route("/video", func(r chi.Router) {
		r.Get("/stream/{year}/{month}/{day}/{period}/{fileName}", api.StreamVideo)
		r.Get("/thumbnail/{year}/{month}/{day}/{period}", api.GetVideoThumbnailNames)
		r.Get("/thumbnail/{year}/{month}/{day}/{period}/{fileName}", api.GetVideoThumbnail)
		r.Post("/extract", api.ExtractVideos)
	})

	fmt.Println("Listening on port 3001")
	http.ListenAndServe(":3001", r)
}
