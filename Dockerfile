
# Build stage
FROM golang:1.23-alpine AS builder

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container
COPY . .

# Build the Go application
RUN go build -o pocketbase_max ./app/main.go

# Final stage
FROM scratch

# Copy the built binary from the build stage
COPY --from=builder /app/pocketbase_max /

# Expose the default port your app listens on
EXPOSE 8080

# Define the command to run the application
ENTRYPOINT ["/pocketbase_max serve --http=0.0.0.0:8090"]
