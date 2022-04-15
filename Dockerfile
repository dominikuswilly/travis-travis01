FROM golang:latest as builder
WORKDIR /app
COPY go.mod ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o loan-service cmd/loan-service/*.go
######## Start a new stage from scratch #######
FROM alpine:latest
RUN apk --no-cache add ca-certificates && update-ca-certificates
RUN apk add --no-cache tzdata 
WORKDIR /root/
# ARG firebase
# Copy the Pre-built binary file from the previous stage
COPY --from=builder /travis-travis01 .
RUN mkdir ./config
# COPY --from=builder /app/cmd/loan-service/config/$firebase ./config/service_account.json
ENV TZ=Asia/Jakarta
# Expose port 8082 to the outside world
EXPOSE 8082
# Command to run the executable
ENTRYPOINT ["./travis-travis01"]