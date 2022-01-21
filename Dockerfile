# Build the k6 binary with the extension
FROM golang:1.16.4-buster as builder
WORKDIR /src/

COPY go.mod .
COPY go.sum .

RUN go mod download

COPY . .

RUN go install go.k6.io/xk6/cmd/xk6@latest
RUN xk6 build --output /k6

# Use the operator's base image and override the k6 binary
FROM loadimpact/k6:latest
COPY --from=builder /k6 /usr/bin/k6