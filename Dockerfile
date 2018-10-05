FROM php:7.2-fpm
RUN apt-get update

# Extension
# Curl
RUN apt-get install -y libcurl3-dev && docker-php-ext-install curl
# Mysql & Mysqli
RUN docker-php-ext-install mysqli pdo pdo_mysql
# ImageMagic
RUN apt-get install -y libmagickwand-dev --no-install-recommends && pecl install imagick && docker-php-ext-enable imagick
# JSON
RUN docker-php-ext-install json
# ZIP
RUN apt-get install -y zlib1g-dev && docker-php-ext-configure zip --with-zlib-dir=/usr && docker-php-ext-install zip

# Remove apt lists to reduce image size
RUN rm -rf /var/lib/apt/lists/*
# Optional: error log file for php.
RUN mkdir -p /var/log/fpm/ && touch /var/log/fpm/error.log && chmod 777 /var/log/fpm/error.log
