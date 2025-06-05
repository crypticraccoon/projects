package main

import (
	"context"
	"log"
	"os"
	"server/internal/confs"
	"server/internal/logging"
	"server/internal/mailer"
	"server/internal/otel"
	"server/internal/server"
	"server/internal/utils"
	"strconv"
)

func main() {

	if err := utils.LoadEnv(); err != nil {
		log.Fatal("Failed to load dot files: " + err.Error())
	}
	ctx := context.Background()

	mailerConfig, err := confs.InitMailerConfig()
	if err != nil {
		log.Fatal("Failed to initialize mailer config: " + err.Error())
	}

	mailer.NewMailer(ctx, mailerConfig)

	serverConfig, err := confs.InitServerConfig()
	if err != nil {
		log.Fatal("Failed to initialize server config: " + err.Error())
	}

	s := server.New(ctx, serverConfig)
	if err := s.Init(); err != nil {
		log.Fatal("Failed to initialize server: " + err.Error())
	}

	otelConfig, err := confs.InitOtelConfig(ctx)
	if err != nil {
		log.Fatal("Failed to init otel configuration: " + err.Error())
	}

	o := otel.New(ctx, otelConfig)

	otelShutdown, err := o.Start()
	if err != nil {
		log.Fatal("Failed to initialize otel: " + err.Error())
	}
	defer otelShutdown()

	logsEnabled, err := strconv.ParseBool(os.Getenv("OTEL_LOGS_ENABLED"))
	if err != nil {
		log.Fatal("Failed to initialize otel: " + err.Error())
	}

	if logsEnabled {
		logging.Init(ctx, o.Logger)
	}

	s.Start()
}
