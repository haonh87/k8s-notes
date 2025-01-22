# usage
# docker build --no-cache -f Dockerfile -t haonh87/php:e-voucher-base .
FROM haonh87/php:7.2-fpm-nginx

# Cài đặt các gói cần thiết
RUN apk update && apk add --no-cache \
    nodejs=12.22.12-r0 \
    npm

# Kiểm tra Node.js và npm đã được cài đặt
RUN node -v && npm -v


EXPOSE 80 443 9003
