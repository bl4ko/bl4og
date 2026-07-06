FROM alpine:3.24@sha256:28bd5fe8b56d1bd048e5babf5b10710ebe0bae67db86916198a6eec434943f8b AS builder
WORKDIR /app
RUN apk add --no-cache hugo
COPY . .
RUN hugo --source=/app --destination=/app/public

FROM nginxinc/nginx-unprivileged:alpine-slim@sha256:defdc1caa3ea8401e9b6b2a5d336c1e3d17c6243fa4e12e6c3a466a16fb137ea

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
