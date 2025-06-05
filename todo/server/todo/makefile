MAIN_PATH=internal/cmd/main.go
BINARY_NAME=main

all: run

build:
	go build ${MAIN_PATH} -v -o ./test .
	#./${BINARY_NAME}
 
run:
	go run ${MAIN_PATH}
 
clean:
	go clean
	rm ${BINARY_NAME}


deps:
	go get github.com/go-chi/chi/v5 \
	github.com/go-chi/cors  \
	github.com/go-chi/httprate \
	github.com/gofrs/uuid \
	github.com/golang-jwt/jwt/v5 \
	github.com/jackc/pgx/v5 \
	github.com/joho/godotenv \
	go.opentelemetry.io/contrib/instrumentation/net/http/otelhttp \
	go.opentelemetry.io/otel \
	go.opentelemetry.io/otel/exporters/otlp/otlplog/otlploghttp \
	go.opentelemetry.io/otel/exporters/otlp/otlptrace \
	go.opentelemetry.io/otel/exporters/otlp/otlptrace/otlptracehttp \
	go.opentelemetry.io/otel/log \
	go.opentelemetry.io/otel/sdk \
	go.opentelemetry.io/otel/sdk/log \
	golang.org/x/crypto \
	gopkg.in/gomail.v2 


