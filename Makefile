# Variables
SSL_DIR=/etc/ssl/custom
DOMAIN=syncworld.loc
PG_DEFAULT_USER=postgres
PG_CONFIG_DATABASE=postgres
DB_CONNECTION=pgsql
DB_HOST=db
DB_PORT=5432
DB_DATABASE=syncworld_db
DB_USERNAME=syncworld_username
DB_PASSWORD=syncworld_password
TEST_DB_USERNAME=syncworld_username_test
TEST_DB_PASSWORD=syncworld_password_test
TEST_DB_DATABASE=syncworld_db_test

# Default task
all: up setup-env laravel-setup #unit-test

# Docker Operations
up: setup-env-files
	@echo "Starting Docker containers..."
	docker-compose up -d

down:
	@echo "Stopping Docker containers..."
	docker-compose down

restart: down up

rebuild:
	@echo "Rebuilding Docker containers..."
	docker-compose down
	docker-compose up --build -d

# Environment Setup
setup-env-files:
	@echo "Setting up environment files..."
	if [ ! -f .env ]; then cp .env.example .env; fi
	if [ ! -f .env.testing ]; then cp .env.example .env.testing; fi

set-env-credentials:
	# Modify .env with given credentials
	sed -i "s/DB_CONNECTION=.*/DB_CONNECTION=$(DB_CONNECTION)/" .env
	sed -i "s/DB_HOST=.*/DB_HOST=$(DB_HOST)/" .env
	sed -i "s/DB_PORT=.*/DB_PORT=$(DB_PORT)/" .env
	sed -i "s/DB_DATABASE=.*/DB_DATABASE=$(DB_DATABASE)/" .env
	sed -i "s/DB_USERNAME=.*/DB_USERNAME=$(DB_USERNAME)/" .env
	sed -i "s/DB_PASSWORD=.*/DB_PASSWORD=$(DB_PASSWORD)/" .env

	# Modify .env.testing with test
	sed -i "s/DB_CONNECTION=.*/DB_CONNECTION=$(DB_CONNECTION)/" .env.testing
	sed -i "s/DB_HOST=.*/DB_HOST=$(DB_HOST)/" .env.testing
	sed -i "s/DB_PORT=.*/DB_PORT=$(DB_PORT)/" .env.testing
	sed -i "s/DB_USERNAME=.*/DB_USERNAME=$(TEST_DB_USERNAME)/" .env.testing
	sed -i "s/DB_PASSWORD=.*/DB_PASSWORD=$(TEST_DB_PASSWORD)/" .env.testing
	sed -i "s/DB_DATABASE=.*/DB_DATABASE=$(TEST_DB_DATABASE)/" .env.testing

setup-env: setup-env-files set-env-credentials setup-test-database

setup-test-database:
	# Drop the user and database if they exist
	-docker-compose exec db dropdb -U $(DB_USERNAME) --if-exists $(TEST_DB_DATABASE)
	-docker-compose exec db dropuser -U $(DB_USERNAME) --if-exists $(TEST_DB_USERNAME)
	# Create the user and databases
	docker-compose exec db createuser -U $(DB_USERNAME) --superuser --createdb --createrole --login $(TEST_DB_USERNAME)
	docker-compose exec db psql -U $(TEST_DB_USERNAME) -d $(PG_CONFIG_DATABASE) -c "ALTER USER $(TEST_DB_USERNAME) WITH PASSWORD '$(TEST_DB_PASSWORD)';"
	docker-compose exec db createdb -U $(TEST_DB_USERNAME) $(TEST_DB_DATABASE)

# Laravel Operations
laravel-setup: composer-install keygen cache-operations migrate-seed

composer-install:
	docker-compose exec app composer install --optimize-autoloader

keygen:
	docker-compose exec app php artisan key:generate

cache-operations:
	docker-compose exec app php artisan config:cache
	docker-compose exec app php artisan route:cache

migrate-seed:
	docker-compose exec app php artisan migrate --force
	docker-compose exec app php artisan db:seed

# Tests
unit-test:
	@echo "Running unit tests..."
	docker-compose exec app ./vendor/bin/phpunit --testsuite Feature --configuration phpunit.xml

# Cleanup
clean:
	@echo "Cleaning up Docker containers, volumes, and networks..."
	docker-compose down -v
	docker system prune -af
	docker network prune -f

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

reset: down clean clean-laravel up setup-env laravel-setup unit-test
