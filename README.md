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

2. **Laravel & Database Migrations**: After starting the containers, run `make laravel-setup` to set up the necessary database tables.

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


### List Events for an Organization

- **Endpoint**: `/api/v1/list`
- **Method**: `GET`
- **Description**: Fetch a list of event records specific to the authenticated organization.
- **Headers**: `Authorization: Bearer YOUR_TOKEN`


### Retrieve a Specific Event

- **Endpoint**: `/api/v1/{id}`
- **Method**: `GET`
- **Description**: Fetch details of a specific event.
- **Headers**: `Authorization: Bearer YOUR_TOKEN`


### Retrieve a Specific Event

- **Endpoint**: `/api/v1/{id}`
- **Method**: `GET`
- **Description**: Fetch details of a specific event.
- **Headers**: `Authorization: Bearer YOUR_TOKEN`


### Update an Event

- **Endpoint**: `/api/v1/{id}`
- **Method**: `PUT` or `PATCH`
- **Description**: Update a specific event's details.
- **Headers**: `Authorization: Bearer YOUR_TOKEN`
- **Request Payload**:
   ```json
   {
      "event_title": "New Event Title",
      "event_start_date": "2023-07-21 10:00:00",
      "event_end_date": "2023-07-21 15:00:00"
   }


### Delete an Event

- **Endpoint**: `/api/v1/{id}`
- **Method**: `DELETE`
- **Description**: Remove a specific event.
- **Headers**: `Authorization: Bearer YOUR_TOKEN`


## Testing
Tests are located in the tests/Feature directory. Execute tests using:
`make unit-test`


## Error Handling
The API returns suitable HTTP status codes accompanied by a clear message in JSON format for any errors. Example:
   ```json
   {
     "status": "error",
     "message": "Unauthenticated"
   }
