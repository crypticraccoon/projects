package logging

import (
	"context"
	"os"
	"strconv"

	"go.opentelemetry.io/otel/log"
)

var Log Logger

type Logger struct {
	logger      log.Logger
	ctx         context.Context
	debug       bool
	otelEnabled bool
}

func Init(c context.Context, l log.Logger) error {
	debugEnabled, err := strconv.ParseBool(os.Getenv("DEBUG"))
	if err != nil {
		return err
	}
	otelEnabled, err := strconv.ParseBool(os.Getenv("OTEL_LOGS_ENABLED"))
	if err != nil {
		return err
	}

	Log = Logger{
		logger:      l,
		ctx:         c,
		debug:       debugEnabled,
		otelEnabled: otelEnabled,
	}
	return nil
}

func (l *Logger) Error(message string) {

	if l.debug {
		println(message)
	}

	if l.logger != nil {
		rec := log.Record{}
		rec.SetSeverity(log.SeverityError)
		rec.SetBody(log.MapValue(log.String(message, "")))
		l.logger.Emit(l.ctx, rec)
	}
}

func (l *Logger) Debug(message string) {

	if l.debug {
		println(message)
	}
	if l.logger != nil {

		rec := log.Record{}
		rec.SetSeverity(log.SeverityDebug)
		rec.SetBody(log.MapValue(log.String(message, "")))
		l.logger.Emit(l.ctx, rec)

	}
}

func (l *Logger) Info(message string) {
	if l.debug {
		println(message)
	}

	if l.logger != nil {
		rec := log.Record{}
		rec.SetSeverity(log.SeverityInfo)
		rec.SetBody(log.MapValue(log.String(message, "")))
		l.logger.Emit(l.ctx, rec)
	}
}
