clean up will be completed in 12 hours. I am signing out now

# SyncWords API

## Table of Contents

- [Introduction](#introduction)
- [Setup and Installation](#setup-and-installation)
- [API Endpoints](#api-endpoints)
    - [Authentication](#authentication)
    - [List Events for an Organization](#list-events-for-an-organization)
    - [Retrieve a Specific Event](#retrieve-a-specific-event)
    - [Update an Event](#update-an-event)
    - [Delete an Event](#delete-an-event)
- [Error Handling](#error-handling)
- [Testing](#testing)

## Introduction

This repository houses the SyncWords API, a system built using Laravel 8+ and Sanctum. The API facilitates the management and retrieval of event records for authorized users.

## Setup and Installation

1. **Docker Compose**: Ensure Docker and Docker Compose are installed. Run `make up` to start the application and database containers.

2. **Database Migrations**: After starting the containers, run `make laravel-setup` to set up the necessary database tables.

3. **Sanctum Configuration**: The API uses Sanctum for authentication. Ensure that the Sanctum configuration is published and the migrations are run as mentioned in the setup steps above.

## API Endpoints

### Authentication

- **Endpoint**: `/api/auth/token`
- **Method**: `POST`
- **Description**: Authenticate and retrieve a bearer token.
- **Request Payload**:
   ```json
   {
     "username": "your_username",
     "password": "your_password"
   }
