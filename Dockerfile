FROM node:25-alpine AS frontend
WORKDIR /app
RUN apk add --no-cache git
RUN git clone https://github.com/andrewbrdk/Scrawl /app
RUN npm ci --prefix frontend
RUN npm run dist:web --prefix frontend

FROM golang:1.25-alpine as backend
COPY --from=frontend /app /Scrawl
WORKDIR /Scrawl
RUN go build -tags web -o bin/scrawl-web
RUN mkdir -p /app
RUN cp /Scrawl/bin/scrawl-web /app/scrawl-web
WORKDIR /app
RUN rm -r /Scrawl
ENV SCRAWL_DBFILE=/app/scrawl.db

EXPOSE 8080

ENTRYPOINT ["/app/scrawl-web"]
