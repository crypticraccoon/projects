FROM golang:1.23-bookworm

RUN apt update && apt install -y ffmpeg imagemagick libfuse2

WORKDIR /usr/src/app

COPY go.mod go.sum ./
RUN go mod download && go mod verify

COPY . .
RUN go build -v -o /usr/local/bin/app ./

ENV APP_ENV="production"

CMD ["app"]
