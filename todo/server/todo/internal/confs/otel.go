package confs

import (
	"context"
	"os"
	"strconv"

	"go.opentelemetry.io/otel/attribute"
	"go.opentelemetry.io/otel/sdk/resource"
	semconv "go.opentelemetry.io/otel/semconv/v1.26.0"
)

type Otel struct {
	Name           string
	ServiceName    attribute.KeyValue
	Resources      *resource.Resource
	Context        context.Context
	ShutdownTimout int
}

func InitOtelConfig(ctx context.Context) (*Otel, error) {
	serviceName := semconv.ServiceNameKey.String(os.Getenv("OTEL_TRACE_SERVICE_NAME"))
	res, err := initResources(ctx, serviceName)
	if err != nil {
		return nil, err
	}

	shutdownTimeout, err := strconv.Atoi(os.Getenv("OTEL_SHUTDOWN_TIMEOUT"))
	if err != nil {
		return nil, err
	}
	return &Otel{
		Name:           os.Getenv("OTEL_TRACE_SERVICE_NAME"),
		ServiceName:    serviceName,
		Resources:      res,
		Context:        ctx,
		ShutdownTimout: shutdownTimeout,
	}, nil
}

func initResources(ctx context.Context, serviceName attribute.KeyValue) (*resource.Resource, error) {
	res, err := resource.New(ctx, resource.WithAttributes(serviceName))
	if err != nil {
		return nil, err
	}
	return res, nil
}

