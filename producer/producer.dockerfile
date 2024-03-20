# FROM golang:1.21-alpine AS builder
# RUN apk add --no-progress --no-cache gcc musl-dev
# WORKDIR /build
# COPY . .
# RUN go mod download
#
# RUN go build -tags musl -ldflags '-extldflags "-static"' -o /build/main
#
# FROM alpine:latest 
# WORKDIR /app
# COPY --from=builder /build/main .
# ENTRYPOINT ["/app/main"]



FROM golang:1.21-alpine AS builder

RUN set -ex &&\
  apk add --no-progress --no-cache \
  gcc \
  musl-dev

# Set necessary environment variables needed for our image
ENV GO111MODULE=on GOOS=linux GOARCH=amd64

# Move to working directory /build
WORKDIR /build

# Copy the code into the container
COPY . .

RUN go mod download

# Build the application
RUN go build -a -tags musl -installsuffix cgo -ldflags '-extldflags "-static"' -o /build/main

# Build a small image
FROM scratch

COPY --from=builder /build/main /

# Command to run
ENTRYPOINT ["/main"]
