# syntax = docker/dockerfile:1-experimental
# Build stage
FROM golang:1.23-alpine AS builder

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container
COPY . .

# Build the Go application
RUN go build -o pocketbase_dlx ./app/main.go

# Final stage
FROM scratch
#FROM alpine:latest
#RUN apk update && apk add fish
# Copy the built binary from the build stage
COPY --from=builder /app/pocketbase_dlx /
#RUN chmod x+ /app/pocketbase_dlx
# Expose the default port your app listens on
EXPOSE 8090

# Define the command to run the application
ENTRYPOINT ["/pocketbase_dlx"]
CMD ["serve", "--http=0.0.0.0:8090"]
