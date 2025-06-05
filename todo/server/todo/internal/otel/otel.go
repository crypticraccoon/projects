package otel

import (
	"context"
	"errors"
	"os"
	"server/internal/confs"
	"server/internal/logging"
	"strconv"
	"time"

	"go.opentelemetry.io/otel"
	log "go.opentelemetry.io/otel/log"
	"go.opentelemetry.io/otel/log/global"
	"go.opentelemetry.io/otel/propagation"
)

type Otel struct {
	ctx    context.Context
	Logger log.Logger
	config *confs.Otel
}

func New(ctx context.Context, config *confs.Otel) *Otel {
	return &Otel{
		ctx:    ctx,
		config: config,
	}
}

func (o *Otel) Start() (func() error, error) {

	var shutdownFunc []func(ctx context.Context) error

	tracesShutdownFunc, err := o.initTraces()
	if err != nil {
		return nil, err
	}

	logsShutdownFunc, err := o.initLogs()
	if err != nil {
		return nil, err
	}

	shutdownFunc = append(shutdownFunc, tracesShutdownFunc, logsShutdownFunc)

	Shutdown := func() error {
		println("Otel shutting down")
		var shutdownErrors error

		for i := range shutdownFunc {
			if err := shutdownFunc[i](o.ctx); err != nil {
				shutdownErrors = errors.Join(err)
			}
		}
		return shutdownErrors
	}
	return Shutdown, nil
}

func (o *Otel) initTraces() (func(ctx context.Context) error, error) {

	tracesEnabled, err := strconv.ParseBool(os.Getenv("OTEL_TRACES_ENABLED"))

	if err != nil {
		return nil, err
	}
	if tracesEnabled {
		tracesProvider, tracesShutdown, err := o.initTracerProvider()
		if err != nil {
			return nil, err
		}
		otel.SetTextMapPropagator(propagation.NewCompositeTextMapPropagator(propagation.TraceContext{}, propagation.Baggage{}))
		otel.SetTracerProvider(tracesProvider)

		return tracesShutdown, nil
	}
	return func(ctx context.Context) error { return nil }, nil
}

func (o *Otel) initLogs() (func(ctx context.Context) error, error) {
	logsEnabled, err := strconv.ParseBool(os.Getenv("OTEL_LOGS_ENABLED"))

	if err != nil {
		return nil, err
	}

	if logsEnabled {
		logsProvider, logsShutdown, err := o.initLoggerProvider()
		if err != nil {
			return nil, err
		}
		o.Logger = logsProvider.Logger(os.Getenv("OTEL_LOGS_NAME"))
		global.SetLoggerProvider(logsProvider)
		logging.Log.Info(time.Now().String())
		return logsShutdown, nil

	}
	return func(ctx context.Context) error { return nil }, nil
}
