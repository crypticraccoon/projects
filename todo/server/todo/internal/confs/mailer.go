package confs

import (
	"os"
	"strconv"
)

type Mailer struct {
	Host       string
	Port       int
	Password   string
	UserEmail  string
	AdminEmail string
	Enabled    bool
}

func InitMailerConfig() (*Mailer, error) {

	port, err := strconv.Atoi(os.Getenv("SMTP_PORT"))
	if err != nil {
		return nil, err
	}

	enabled, err := strconv.ParseBool(os.Getenv("SMTP_ENABLED"))
	if err != nil {
		return nil, err
	}

	return &Mailer{
		Host:       os.Getenv("SMTP_HOST"),
		Port:       port,
		Password:   os.Getenv("SMTP_PASS"),
		UserEmail:  os.Getenv("SMTP_USER"),
		AdminEmail: os.Getenv("SMTP_ADMIN_EMAIL"),
		Enabled:    enabled,
	}, nil
}
