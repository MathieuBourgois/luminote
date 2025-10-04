FROM node:18-alpine AS builder

WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

FROM alpine:latest

RUN apk add --no-cache lighttpd
COPY --from=builder /app/dist /var/www/localhost/htdocs
RUN mv /var/www/localhost/htdocs/luminote.html /var/www/localhost/htdocs/index.html
RUN echo 'server.error-handler-404 = "/404.html"' >> /etc/lighttpd/lighttpd.conf
RUN echo 'server.tag = ""' >> /etc/lighttpd/lighttpd.conf

EXPOSE 80
CMD ["lighttpd", "-D", "-f", "/etc/lighttpd/lighttpd.conf"]
