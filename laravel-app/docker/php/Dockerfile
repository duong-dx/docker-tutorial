FROM php:7.4-fpm

# Install system dependencies
USER root

RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip

# Install composer
#RUN cd ~
#
#RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
#RUN HASH=`curl -sS https://composer.github.io/installer.sig`
#RUN echo $HASH
#RUN php -r "if (hash_file('SHA384', '/tmp/composer-setup.php') === '$HASH') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
#RUN php /tmp/composer-setup.php --install-dir=/usr/local/bin --filename=composer

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# xDebug:
ARG PHP_XDEBUG_ENABLE=false
ARG PHP_XDEBUG_VERSION=laste
RUN if [ ${PHP_XDEBUG_ENABLE} = true ]; then \
    pecl install "xdebug-${PHP_XDEBUG_VERSION}" && \
    docker-php-ext-enable xdebug \
;fi


# Copy xdebug configuration for remote debugging
COPY xdebug.ini /usr/local/etc/php/conf.d/

ARG PHP_XDEBUG_REMOTE_CONNECT_BACK=false
RUN if [ ${PHP_XDEBUG_REMOTE_CONNECT_BACK} = true ]; then \
    echo "xdebug.remote_connect_back=1" >> /usr/local/etc/php/conf.d/xdebug.ini \
;fi

# Copy php.ini into docker php
COPY php.ini /usr/local/etc/php/php.ini

# Set Timezone
ARG TZ=UTC
ENV TZ ${TZ}
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Arguments defined in docker-compose.yml
ARG user=user
ARG uid=123321
# Create system user to run Composer and Artisan Commands
RUN useradd -G www-data,root -u $uid -d /home/$user $user || echo "User already exists."
RUN mkdir -p /home/$user/.composer && \
    chown -R $user:$user /home/$user


# Crontab
USER root
COPY crontab /etc/cron.d
RUN chmod -R 644 /etc/cron.d

# Install cron
RUN apt-get update && apt-get -y install cron

# Set crontab
RUN (crontab -l; echo "* * * * * cd /var/www/project && php artisan schedule:run >> /dev/null 2>&1") | crontab

# Set working directory
WORKDIR /var/www

USER $user
