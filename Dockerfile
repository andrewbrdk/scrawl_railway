FROM golang:1.25-alpine

RUN apk add --no-cache \
    bash \
    git \
    wget

RUN git clone https://github.com/andrewbrdk/Scrawl /Scrawl
WORKDIR /Scrawl
RUN npm ci --prefix frontend
RUN npm run dist:web --prefix frontend
RUN go build -tags web -o bin/scrawl-web
RUN mkdir -p /app
RUN cp /Scrawl/bin/scrawl-web /app/scrawl-web
WORKDIR /app
RUN rm -r /Scrawl
ENV SCRAWL_DBFILE=/app/scrawl.db

EXPOSE 8080

ENTRYPOINT ["/app/scrawl-web"]
