#syntax=docker/dockerfile:1
#
#FROM golang:1.23.1
#
#WORKDIR /app
#
#COPY go.mod go.sum ./
#RUN go mod download
#
#COPY . ./
#
#RUN CGO_ENABLED=0 GOOS=linux go build -o /go-webapp-sample
#
#EXPOSE 8080
#
#CMD ["/go-webapp-sample"]

#----------------------------------------------------------------

# Mutli-stage build from source
FROM golang:1.23.1 AS build-stage

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . ./

RUN CGO_ENABLED=0 GOOS=linux go build -v -o /go-webapp-sample

# Deploy the application binary into a lean image
FROM gcr.io/distroless/base-debian11 AS build-release-stage

WORKDIR /

COPY --from=build-stage /go-webapp-sample /go-webapp-sample

EXPOSE 8080

ENTRYPOINT ["/go-webapp-sample"]