# ----- Stage 1: Build -----
FROM golang:1.24-bookworm AS builder

RUN apt-get update && apt-get install -y \
    librdkafka-dev \
    gcc \
    pkg-config

WORKDIR /app

# Cache dependencies
COPY go.mod go.sum ./
RUN cat go.mod
RUN cat go.sum

RUN go mod download

# Copy the source
COPY . .

# Build the binary
RUN go build -o kafkaapp ./cmd/kafkaapp

# ----- Stage 2: Runtime -----
FROM debian:bookworm-slim

WORKDIR /root/

# Copy the binary from the builder
COPY --from=builder /app/kafkaapp .

# Expose port (optional)
#EXPOSE 8080

# Run the app
ENTRYPOINT ["./kafkaapp"]