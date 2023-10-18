FROM alpine:latest as builder
WORKDIR /app
RUN apk add --no-cache hugo
COPY . .
RUN hugo --source=/app --destination=/app/public

FROM nginx:1.25.2-alpine3.18-slim
COPY --from=builder /app/public /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]