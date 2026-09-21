FROM alpine:3.24@sha256:294b683cb724975bec92580e1e685676bd4b50bda910ddb8c51d4cabeaec77e6 AS builder
WORKDIR /app
RUN apk add --no-cache hugo
COPY . .
RUN hugo --source=/app --destination=/app/public

FROM nginxinc/nginx-unprivileged:alpine-slim@sha256:f08c8378b2ac3a544e3e9ee664c3efb733b5aa53c774ca4ec8d5d0cc641d9e88

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
