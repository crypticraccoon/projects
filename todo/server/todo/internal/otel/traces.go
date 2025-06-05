package otel

import (
	"context"

	"go.opentelemetry.io/otel/exporters/otlp/otlptrace"
	"go.opentelemetry.io/otel/exporters/otlp/otlptrace/otlptracehttp"
	sdktrace "go.opentelemetry.io/otel/sdk/trace"
)

func (o *Otel) initTracerProvider() (*sdktrace.TracerProvider, func(ctx context.Context) error, error) {
	traceExporter, err := otlptrace.New(context.Background(), otlptracehttp.NewClient())
	if err != nil {
		return nil, nil, err
	}

	bsp := sdktrace.NewBatchSpanProcessor(traceExporter)
	provider := sdktrace.NewTracerProvider(
		sdktrace.WithSampler(sdktrace.AlwaysSample()),
		sdktrace.WithResource(o.config.Resources),
		sdktrace.WithSpanProcessor(bsp),
	)

	shutdown := func(ctx context.Context) error {
		if err := provider.Shutdown(ctx); err != nil {
			return err
		}
		return nil
	}
	return provider, shutdown, nil
}
