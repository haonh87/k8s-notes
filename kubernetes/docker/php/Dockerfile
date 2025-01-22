# usage
# docker build --no-cache -f Dockerfile -t haonh87/php:8.4-fpm-nginx .

ARG PHP_FPM_IMAGE_BASE_TAG=8.4-fpm-alpine
ARG LIBRDKAFKA_VERSION

FROM php:$PHP_FPM_IMAGE_BASE_TAG

LABEL maintainer="Hao Nguyen <haonh.87@gmail.com>"
LABEL description="php-fpm alpine"

# # #
# INSTALL SYSTEM DEPENDENCES
# # #
RUN apk update && apk upgrade && \
    apk add --no-cache \
        wget curl ca-certificates gcc tzdata bash linux-headers icu-dev \
        libpng-dev libjpeg-turbo-dev libwebp-dev libxpm-dev libzip-dev \
        oniguruma-dev libxml2-dev g++ make cmake autoconf openssl-dev \
        postgresql-dev bzip2-dev imagemagick-dev gmp-dev libxslt-dev \
        zlib-dev nginx redis supervisor git && \
    rm -rf /var/cache/apk/* && \
        rm -Rf /etc/nginx/nginx.conf && \
        rm -Rf /etc/nginx/conf.d/default.conf

# # #
# PHP EXTENSIONS
# # #
RUN docker-php-ext-configure gd --with-jpeg --with-webp && \
    docker-php-ext-install -j$(nproc) \
        gd intl zip pdo pdo_mysql pdo_pgsql pgsql mbstring exif gmp pcntl \
        bcmath xsl opcache bz2 session sockets && \
    docker-php-ext-enable sockets && \
    rm -rf /tmp/pear

# Tải và cài đặt librdkafka 2.8.0 từ GitHub
RUN curl -L -o /tmp/librdkafka.tar.gz https://github.com/confluentinc/librdkafka/archive/refs/tags/v2.7.0.tar.gz \
    && tar -xvzf /tmp/librdkafka.tar.gz -C /tmp \
    && cd /tmp/librdkafka-2.7.0 \
    && ./configure \
    && make \
    && make install \
    && rm -rf /tmp/librdkafka*

# Cài đặt PHP extension rdkafka qua PECL
RUN pecl install rdkafka \
    && docker-php-ext-enable rdkafka


# # #
#  INSTALL COMPOSER
# # #
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# # #
# CONFIGURE NGINX
# HTTP
# Default server
# # #
COPY configs/nginx/nginx.conf /etc/nginx/nginx.conf
COPY configs/nginx/conf.d /etc/nginx/conf.d/

# # #
# CONFIGURE PHP-FPM
# # #
COPY configs/php/fpm-pool.conf /usr/local/etc/php-fpm.d/www.conf
COPY configs/php/php.ini /usr/local/etc/php/conf.d/custom.ini
# COPY configs/php/xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini
#COPY config/php/opcache.ini /usr/local/etc/php/conf.d/opcache.ini

# CONFIGURE SUPERVISORD
COPY configs/supervisord/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# SETUP DOCUMENT ROOT
WORKDIR /var/www/html

# COPY SCRIPTS
COPY ./start.sh /start.sh
RUN chmod +x /start.sh

# PORT 9003 FOR X-DEBUG
EXPOSE 80 443 9003

# FOR PHP-FPM
#EXPOSE 9000

CMD ["/start.sh"]