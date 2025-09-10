# Notes API

A Ruby on Rails API for managing notes with JWT-based authentication using Devise and Warden.

## Features

- User registration and login
- JWT authentication for secure API access
- User logout with token revocation
- CRUD operations for notes (to be implemented / extendable)
- JSON responses for all endpoints
- RSpec tests for authentication

## Technologies Used

- Ruby 3.4
- Rails 8.0
- Devise for authentication
- Warden JWT Auth for token-based authentication
- RSpec for testing
- Rack-CORS for handling cross-origin requests

## API Endpoints

### Authentication

| Method | Endpoint | Description                 |
| ------ | -------- | --------------------------- |
| POST   | /signup  | Register a new user         |
| POST   | /login   | Login and receive JWT token |
| DELETE | /logout  | Logout and revoke JWT token |

### Notes (Example)

| Method | Endpoint   | Description         |
| ------ | ---------- | ------------------- |
| GET    | /notes     | Fetch all notes     |
| POST   | /notes     | Create a new note   |
| GET    | /notes/:id | Fetch a single note |
| PATCH  | /notes/:id | Update a note       |
| DELETE | /notes/:id | Delete a note       |

## Installation

1. Clone the repository:

```bash
git clone https://github.com/<your-username>/notes_api.git
cd notes_api
```
2. Install dependencies 

```bash
bundle install
```
3. Set up the database:
```bash
Set up the database:
```

4. Run the server:
```bash
rails s
```

The api will be available at ```http://localhost:3000```

### Testing
Run the RSpec test suite with:
```bash
bundle exec rspec
```

### Notes
- Make sure to include ```Authorization: Bearer <JWT_TOKEN>``` in headers for protected endpoints.
- Extend the Notes controller to implement full CRUD functionality.
