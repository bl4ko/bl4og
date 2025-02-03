FROM alpine:3.21.2 as builder
WORKDIR /app
RUN apk add --no-cache hugo
COPY . .
RUN hugo --source=/app --destination=/app/public

FROM nginx:1.27.3-alpine3.20-slim

# Create a non-root user and group
RUN addgroup -S nginx && adduser -S nginx -G nginx

# Set permissions for the non-root user
RUN chown -R nginx:nginx /usr/share/nginx/html /var/cache/nginx /var/run

# Switch to the non-root user
USER nginx

COPY --from=builder /app/public /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
