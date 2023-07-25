# Variables
SSL_DIR=/etc/ssl/custom
DOMAIN=starrynight.loc
DB_USERNAME=your_db_username
DB_PASSWORD=your_db_password
DB_TEST_DATABASE=your_db_test_database_name

# Default task
all: up setup-env laravel-setup unit-test

# Start the Docker containers
up:
	@echo "Starting Docker containers..."
	docker-compose up -d

# Generate self-signed SSL certificates inside the container
generate-ssl:
	@echo "Generating SSL certificates..."
	docker-compose exec app mkdir -p $(SSL_DIR)
	docker-compose exec app openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
		-keyout $(SSL_DIR)/selfsigned.key -out $(SSL_DIR)/selfsigned.crt \
		-subj "/C=US/ST=State/L=City/O=Org/CN=$(DOMAIN)" || echo "Failed to generate SSL certificates"

# Set up the environment files
setup-env:
	@echo "Setting up environment files..."
	docker-compose exec app cp .env.example .env
	docker-compose exec app cp .env.testing.example .env.testing
	#docker-compose exec db createdb -U $(DB_USERNAME) $(DB_TEST_DATABASE)
	sleep 5 # Add a small delay here to wait for PostgreSQL service to start
	docker-compose exec db createuser -U tel --superuser --createdb --createrole --login $(DB_USERNAME)
	docker-compose exec db createdb -U $(DB_USERNAME) $(DB_TEST_DATABASE)
	docker-compose exec db psql -U $(DB_USERNAME) -c "ALTER USER $(DB_USERNAME) WITH PASSWORD '$(DB_PASSWORD)';"

# Run Laravel installation and setup commands
laravel-setup:
	@echo "Setting up Laravel..."
	docker-compose exec app composer install --optimize-autoloader --no-dev
	docker-compose exec app php artisan key:generate
	docker-compose exec app php artisan config:cache
	docker-compose exec app php artisan route:cache
	docker-compose exec app php artisan migrate --force
	docker-compose exec app php artisan db:seed

# Run Laravel unit tests
unit-test:
	@echo "Running unit tests..."
	docker-compose exec app ./vendor/bin/phpunit --testsuite Unit

# Stop and remove Docker containers
down:
	@echo "Stopping Docker containers..."
	docker-compose down

# Restart Docker containers
restart: down up

# Rebuild Docker containers
rebuild:
	@echo "Rebuilding Docker containers..."
	docker-compose down
	docker-compose up --build -d

# Additional tasks for cleaning up or other operations can be added as needed

# Task to clean up Docker volumes (use with caution)
clean-volumes:
	@echo "Cleaning up Docker volumes..."
	docker volume prune -f

# Task to clean up Laravel cache and logs
clean-laravel:
	@echo "Cleaning up Laravel cache and logs..."
	docker-compose exec app php artisan cache:clear
	docker-compose exec app php artisan route:clear
	docker-compose exec app php artisan config:clear
	docker-compose exec app php artisan view:clear
	rm -rf storage/framework/cache/*
	rm -rf storage/framework/sessions/*
	rm -rf storage/framework/views/*
	rm -rf storage/logs/*

# Task to reset the entire project (use with caution)
reset: down clean-volumes clean-laravel up generate-ssl setup-env laravel-setup unit-test
