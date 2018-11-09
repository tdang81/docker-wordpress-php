FROM php:7.1-fpm

RUN apt-get update

# Extension
# Curl
RUN apt-get install -y libcurl3-dev && docker-php-ext-install curl
# Mysql & Mysqli
RUN docker-php-ext-install mysqli pdo pdo_mysql
# ImageMagic
RUN export CFLAGS="$PHP_CFLAGS" CPPFLAGS="$PHP_CPPFLAGS" LDFLAGS="$PHP_LDFLAGS" \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        libmagickwand-dev \
    && pecl install imagick-3.4.3 \
    && docker-php-ext-enable imagick

# GD
RUN apt-get install -y libjpeg-dev libpng-dev libfreetype6-dev
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/
RUN docker-php-ext-install gd
# Soap
RUN apt-get install -y libxml2-dev
RUN docker-php-ext-install soap
# ZIP
RUN apt-get install -y zlib1g-dev && docker-php-ext-configure zip --with-zlib-dir=/usr && docker-php-ext-install zip

#wp cli
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x wp-cli.phar
RUN mv wp-cli.phar /usr/local/bin/wp

#composer
RUN apt-get install -y unzip
RUN curl -sS https://getcomposer.org/installer -o composer-setup.php
RUN php composer-setup.php --install-dir=/usr/local/bin --filename=composer

#Mailhog
RUN apt-get install --no-install-recommends --assume-yes --quiet ca-certificates curl git &&\
    rm -rf /var/lib/apt/lists/*
RUN curl -Lsf 'https://storage.googleapis.com/golang/go1.8.3.linux-amd64.tar.gz' | tar -C '/usr/local' -xvzf -
#ENV PATH /usr/local/go/bin:$PATH
RUN /usr/local/go/bin/go get github.com/mailhog/mhsendmail
RUN cp /root/go/bin/mhsendmail /usr/bin/mhsendmail

# Remove apt lists to reduce image size
RUN rm -rf /var/lib/apt/lists/*
# Optional: error log file for php.
RUN mkdir -p /var/log/fpm/ && touch /var/log/fpm/error.log && chmod 777 /var/log/fpm/error.log
