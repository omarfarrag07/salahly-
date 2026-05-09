# Kafa2a - Laravel Backend

This is the backend API for the Kafa2a app (Salahly), a platform connecting users with service providers like carpenters, electricians, drivers, mechanics, babysitters, and more.

## 📦 Tech Stack

- **Laravel 12**
- **Laravel Sanctum** for API authentication
- **PostgreSQL**
- **Pusher** (for real-time messaging)
- **Flutter** frontend (mobile app)

---

## 🚀 Getting Started

### 1. Download the repository


2. Install dependencies

bash : composer install

3. Copy and configure .env

bash : cp .env.example .env

Edit your .env file:

APP_NAME=Kafa2a
APP_URL=http://127.0.0.1:8000

DB_CONNECTION=pgsql
DB_HOST=127.0.0.1
DB_PORT=5432
DB_DATABASE=kafa2a
DB_USERNAME=your_db_username
DB_PASSWORD=your_db_password

SANCTUM_STATEFUL_DOMAINS=localhost:8000

PUSHER_APP_ID=your_app_id
PUSHER_APP_KEY=your_app_key
PUSHER_APP_SECRET=your_app_secret
PUSHER_APP_CLUSTER=mt1


4. Generate application key

php artisan key:generate



5. Run database migrations

php artisan migrate

(Optional: run seeders if defined)

php artisan db:seed




6. Serve the project

bash: php artisan serve

Your API will be available at:
http://127.0.0.1:8000


🔐 Authentication & Login
📌 Register

    User: POST /api/register

    Provider: POST /api/register-provider

🔐 Login

    Endpoint: POST /api/token

    Body (JSON):

{
  "email": "user@example.com",
  "password": "yourpassword"
}

    Response:

{
  "token": "your-api-token",
  "user": {
    "id": 1,
    "name": "John Doe",
    ...
  }
}

Use the token in the header for authenticated requests:


Authorization: Bearer your-api-token


📲 Flutter Integration

    Pass Authorization: Bearer <token> in all secure requests

    Use Accept: application/json header

    Send login/register body as raw JSON, not form-data

    Upload files as multipart/form-data

    If using chat, configure Pusher on both Laravel and Flutter sides



📁 Folder Structure

Kafa2a/
├── app/
│   ├── Http/Controllers/
│   ├── Models/
│   └── ...
├── database/
│   ├── migrations/
│   └── seeders/
├── routes/
│   └── api.php
├── .env
└── README.md


🧪 Testing with Postman
✅ Headers

Accept: application/json
Content-Type: application/json

Example Login Request

POST /api/token
Body:

{
  "email": "test@example.com",
  "password": "12345678"
}



📌 API Features
Feature	Endpoint
Register User	POST /api/register
Register Provider	POST /api/register-provider
Login & Token	POST /api/token
Service Requests	GET /api/service-requests
Offers	GET /api/offers
Messaging (Chat)	POST /api/messages
Ratings	POST /api/ratings
Categories	GET /api/categories
Admin Dashboard	GET /api/admin/dashboard


🧪 Run Laravel Tests

bash: php artisan test


🧹 Common Issues & Fixes

    ❌ Empty or HTML responses: Make sure you’re using Accept: application/json

    ❌ Invalid token error: Ensure you're logged in and passing the token correctly



    🔄 After .env updates:

    php artisan config:clear
    php artisan cache:clear
    php artisan route:clear




