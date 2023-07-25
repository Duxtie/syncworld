# Variables
SSL_DIR=/etc/ssl/custom
DOMAIN=starrynight.loc

# Default task
all: up generate-ssl setup-env laravel-setup unit-test

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
		-subj /"/C=US/ST=State/L=City/O=Org/CN=$(DOMAIN)" || echo "Failed to generate SSL certificates"

# Set up the environment files
setup-env:
	@echo "Setting up environment files..."
	docker-compose exec app cp .env.testing .env
	docker-compose exec postgres createdb -U $(DB_USERNAME) $(DB_TEST_DATABASE)

# Run Laravel installation and setup commands
laravel-setup:
	@echo "Setting up Laravel..."
	#docker-compose exec app composer install --optimize-autoloader --no-dev
	#docker-compose exec app php artisan config:cache
	#docker-compose exec app php artisan route:cache
	#docker-compose exec app php artisan migrate --force
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
