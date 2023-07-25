#!/bin/bash

GREEN='\033[0;32m'  # ANSI escape code for green color
NC='\033[0m'       # ANSI escape code to reset color

echo -e "${GREEN}Started executing startup.sh ...${NC}"


# Set permissions and ownership
chown -R $USER:www-data /var/www
find /var/www -type f -exec chmod 664 {} \;
find /var/www -type d -exec chmod 775 {} \;

# Install Laravel dependencies & Create Laravel storage symlink
composer install --no-interaction --prefer-dist --optimize-autoloader --no-dev  --ignore-platform-reqs
php artisan storage:link

# You can uncomment the following lines if you want to run migrations and seeding every time the container starts up
php artisan migrate
php artisan db:seed

service apache2 restart
/usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf
php artisan migrate && php artisan db:seed

echo -e "${GREEN}Finished executing startup.sh ...${NC}"
