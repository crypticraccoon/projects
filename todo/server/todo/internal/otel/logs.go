package otel

import (
	"context"

	"go.opentelemetry.io/otel/exporters/otlp/otlplog/otlploghttp"
	"go.opentelemetry.io/otel/sdk/log"
)

func (o *Otel) initLoggerProvider() (*log.LoggerProvider, func(ctx context.Context) error, error) {
	exp, err := otlploghttp.New(o.ctx)
	if err != nil {
		return nil, func(ctx context.Context) error { return nil }, err
	}

	processor := log.NewBatchProcessor(exp)
	provider := log.NewLoggerProvider(log.WithProcessor(processor))

	shutdown := func(ctx context.Context) error {
		if err := provider.Shutdown(ctx); err != nil {
			return err
		}
		return nil
	}

	return provider, shutdown, nil
}
