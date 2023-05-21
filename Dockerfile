# Start by building the application.
FROM golang:1.19-alpine as build

WORKDIR /go/src/app
COPY . .

RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser

RUN go mod download && \
    CGO_ENABLED=0 go build -o /go/bin/app.bin cmd/main.go && \
    chmod +x /go/bin/app.bin

FROM scratch
COPY --from=build /go/bin/app.bin /go/bin/app.bin
COPY --from=build /etc/passwd /etc/passwd

VOLUME /upload
EXPOSE 9999

USER appuser
ENTRYPOINT ["/go/bin/app.bin"]
