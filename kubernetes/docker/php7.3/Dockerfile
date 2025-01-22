# usage
# docker build --no-cache -f Dockerfile -t haonh87/php:7.3-fpm-nginx .

ARG BASE_TAG=7.3-fpm-alpine3.12

FROM php:$BASE_TAG

LABEL maintainer="Hao Nguyen <haonh.87@gmail.com>"
LABEL description="php-fpm 7.3 alpine"

# # #
# INSTALL SYSTEM DEPENDENCES
# # #
RUN apk update && apk upgrade && \
    apk add --no-cache wget curl ca-certificates gcc \
        tzdata \
        s6 ssmtp \
        bash \
        linux-headers \
        icu-dev \
        libpng-dev \
        libjpeg-turbo-dev \
        libwebp-dev \
        libxpm-dev \
        libzip-dev \
        oniguruma-dev \
        libxml2-dev \
        g++ \
        make \
        cmake \
        autoconf \
        openssl-dev \
        postgresql-dev \
        bzip2-dev \
        imagemagick \
        imagemagick-dev \
        libtool \
        libmcrypt-dev \
        gmp-dev \
        libxslt-dev \
        zlib-dev \
        nginx \
        supervisor && \
        rm /var/cache/apk/* && \
        rm -Rf /etc/nginx/nginx.conf && \
        rm -Rf /etc/nginx/conf.d/default.conf

# # #
# PHP EXTENSIONS
# # #
RUN docker-php-ext-configure gd \
    --with-freetype-dir=/usr/include/ \
    --with-jpeg-dir=/usr/include/ \
    --with-png-dir=/usr/include/ \
    ; \
    docker-php-ext-install -j"$(getconf _NPROCESSORS_ONLN)" \
    gd \
    intl \
    zip \
    pdo \
    pdo_mysql \
    pdo_pgsql \
    pgsql \
    mbstring \
    exif \
    gmp \
    pcntl \
    bcmath \
    xsl \
    opcache \
    bz2 \
    session \
    sockets \
    ; \
    \
    pecl update-channels; \
    pecl install \
        imagick \
        redis \
        xdebug \
    ; \
    docker-php-ext-enable imagick redis; \
    rm -rf /tmp/pear ~/.pearrc; \
    \
    runDeps="$( \
        scanelf --needed --nobanner --format '%n#p' --recursive /usr/local \
            | tr ',' '\n' \
            | sort -u \
            | awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
    )"; \
    apk add --update --no-cache --virtual .run-deps $runDeps; \
    apk del .build-deps; \
    \
    php --version
    
RUN pecl update-channels; \
    pecl install imagick \
&& docker-php-ext-enable imagick \
&& apk del --no-cache imagemagick-dev libtool autoconf g++ make \
&& rm -rf /tmp/pear ~/.pearrc

# # #
#  INSTALL COMPOSER
# # #
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# # #
#   INSTALL NODEJS AND NPM
# # #
RUN apk update && apk add --no-cache nodejs npm

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
# COPY config/php/opcache.ini /usr/local/etc/php/conf.d/opcache.ini

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