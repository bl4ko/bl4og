FROM alpine:3.21.2@sha256:56fa17d2a7e7f168a043a2712e63aed1f8543aeafdcee47c58dcffe38ed51099 AS builder
WORKDIR /app
RUN apk add --no-cache hugo
COPY . .
RUN hugo --source=/app --destination=/app/public

FROM nginxinc/nginx-unprivileged:1.27.3-alpine3.20-slim@sha256:24ae9a39acde5b55b877c7d2ced48549cfada5ae497a9fe2cd8a9c0cfc15919b

ARG VERSION
ARG CREATED
ARG COMMIT

LABEL \
  org.opencontainers.image.authors="bl4ko" \
  org.opencontainers.image.created=$CREATED \
  org.opencontainers.image.version=$VERSION \
  org.opencontainers.image.revision=$COMMIT \
  org.opencontainers.image.url="https://github.com/bl4ko/bl4og" \
  org.opencontainers.image.documentation="https://github.com/bl4ko/bl4og/blob/main/README.md" \
  org.opencontainers.image.source="https://github.com/bl4ko/bl4og" \
  org.opencontainers.image.title="Bl4og" \
  org.opencontainers.image.description=""

USER nginx

COPY --from=builder /app/public /usr/share/nginx/html
EXPOSE 8080
CMD ["nginx", "-g", "daemon off;"]
