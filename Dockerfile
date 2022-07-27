FROM alpine:latest
LABEL maintainer="Cloudgen Wong <cloudgen@locomodo.io>"

ENV TIMEZONE            Asia/Hong_Kong
ENV PHP_MEMORY_LIMIT    512M
ENV MAX_UPLOAD          50M
ENV PHP_MAX_FILE_UPLOAD 200
ENV PHP_MAX_POST        100M

RUN set -eux; \
  apk update && \
  apk add --no-cache --update tzdata && \
  cp /usr/share/zoneinfo/${TIMEZONE} /etc/localtime && \
  echo "${TIMEZONE}" > /etc/timezone && \
  apk add --no-cache --update \
    php8-soap \
    php8-openssl \
    php8-gmp \
    php8-pdo_odbc \
    php8-json \
    php8-dom \
    php8-pdo \
    php8-zip \
    php8-mysqli \
    php8-sqlite3 \
    php8-pdo_pgsql \
    php8-bcmath \
    php8-gd \
    php8-odbc \
    php8-pdo_mysql \
    php8-pdo_sqlite \
    php8-gettext \
    php8-xmlreader \
    php8-bz2 \
    php8-iconv \
    php8-pdo_dblib \
    php8-curl \
    php8-ctype \
    php8-fpm && \
  sed -i "s|;*daemonize\s*=\s*yes|daemonize = no|g" /etc/php8/php-fpm.conf && \
  sed -i "s|;*listen\s*=\s*127.0.0.1:9000|listen = 9000|g" /etc/php8/php-fpm.d/www.conf && \
  sed -i "s|;*listen\s*=\s*/||g" /etc/php8/php-fpm.d/www.conf && \
  sed -i "s|;*date.timezone =.*|date.timezone = ${TIMEZONE}|i" /etc/php8/php.ini && \
  sed -i "s|;*memory_limit =.*|memory_limit = ${PHP_MEMORY_LIMIT}|i" /etc/php8/php.ini && \
  sed -i "s|;*upload_max_filesize =.*|upload_max_filesize = ${MAX_UPLOAD}|i" /etc/php8/php.ini && \
  sed -i "s|;*max_file_uploads =.*|max_file_uploads = ${PHP_MAX_FILE_UPLOAD}|i" /etc/php8/php.ini && \
  sed -i "s|;*post_max_size =.*|post_max_size = ${PHP_MAX_POST}|i" /etc/php8/php.ini && \
  sed -i "s|;*cgi.fix_pathinfo=.*|cgi.fix_pathinfo= 0|i" /etc/php8/php.ini && \
  mkdir /var/www && \
  echo "<?php phpinfo();" > /var/www/index.php && \
  rm -rf /var/cache/apk/*

WORKDIR /var/www
VOLUME ["/var/www"]
EXPOSE 9000
ENTRYPOINT ["/usr/sbin/php-fpm8"]