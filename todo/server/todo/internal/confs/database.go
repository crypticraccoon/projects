package confs

import (
	"context"
	"os"
	"time"
)

type Database struct {
	Host              string
	Port              int
	Password          string
	User              string
	Database          string
	Context           context.Context
	SslMode           string
	MaxConns          int
	MinConns          int
	MinIdleConns      int
	HealthCheckPeriod time.Duration
}

func InitDatabaseConfig(c context.Context) (*Database, error) {

	return &Database{
		Host:     os.Getenv("DB_HOST"),
		Database: os.Getenv("DB"),
		Password: os.Getenv("DB_PWD"),
		User:     os.Getenv("DB_USER"),
		Context:  c,
	}, nil
}
