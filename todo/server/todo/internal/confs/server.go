package confs

import (
	"os"
	"strconv"
)

type Server struct {
	Host            string
	Port            string
	ShutdownTimeout int
}

func InitServerConfig() (*Server, error) {
	shutdownTimeout, err := strconv.Atoi(os.Getenv("SERVER_SHUTDOWN_TIMEOUT"))
	if err != nil {
		return nil, err
	}
	return &Server{
		Host:            os.Getenv("HOST"),
		Port:            os.Getenv("PORT"),
		ShutdownTimeout: shutdownTimeout,
	}, nil
}

func (d *Server) GetAddress() string {
	return d.Host + ":" + d.Port
}


