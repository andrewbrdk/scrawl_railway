FROM node:25-alpine AS frontend
WORKDIR /app
RUN apk add --no-cache git
RUN git clone https://github.com/andrewbrdk/Scrawl /app
RUN npm ci --prefix frontend
RUN npm run dist:web --prefix frontend

FROM golang:1.26-alpine as backend
RUN apk add --no-cache gcc musl-dev
COPY --from=frontend /app /Scrawl
WORKDIR /Scrawl
RUN CGO_ENABLED=1 go build -tags web -o bin/scrawl-web
RUN mkdir -p /app
RUN mkdir -p /data
RUN cp /Scrawl/bin/scrawl-web /app/scrawl-web
WORKDIR /app
RUN rm -r /Scrawl

EXPOSE 8080

ENTRYPOINT ["/app/scrawl-web"]
