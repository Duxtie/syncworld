FROM php:8.0-apache

# Assign APP_PATH
ENV APP_PATH=/var/www

# Set the working directory in the container
WORKDIR /var/www

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libpq-dev \
    libpng-dev \
    libzip-dev \
    libmcrypt-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libicu-dev \
    redis-tools \
    supervisor \
    zip \
    unzip \
    git \
    curl

# Configure the gd extension
RUN docker-php-ext-configure gd --with-freetype --with-jpeg

# Install PHP extensions
RUN docker-php-ext-install pdo_pgsql pgsql gd zip pcntl

# Add pecl extension for mcrypt (libmcrypt is deprecated in PHP 7.2)
RUN pecl install mcrypt-1.0.4 \
    && docker-php-ext-enable mcrypt

# Install composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Add 'ServerName 127.0.0.1' to apache2.conf
RUN echo 'ServerName 127.0.0.1' >> /etc/apache2/apache2.conf

# Copy existing application directory permissions
COPY . /var/www

# Change Apache DocumentRoot to Laravel's public directory
RUN sed -i 's!/var/www/html!/var/www/public!g' /etc/apache2/sites-available/000-default.conf

# Set permissions and ownership
RUN chown -R $USER:www-data /var/www && find /var/www -type f -exec chmod 664 {} \; && find /var/www -type d -exec chmod 775 {} \;

# Enable apache module rewrite
RUN a2enmod ssl && a2enmod rewrite

EXPOSE 80 443
#USER root
