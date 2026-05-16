# KAFA2A

**KAFA2A** is a mobile application built with **Flutter**, designed to seamlessly connect users with verified service providers across various categories, including home maintenance, repairs, and other personal services. It solves the trust and communication gap between service seekers and providers by offering a structured, secure, and efficient platform.

The app is architected using **Clean Architecture**, leverages **BLoC (Business Logic Component)** for state management, and uses **Dio** for handling all HTTP requests. It also integrates the **Google Maps API** for location services, and leverages **Dependency Injection (DI)** for better modularity, scalability, and testability.

---

## Table of Contents

- [Features](#features)
- [Installation](#installation)
- [Folder Structure](#folder-structure)

---

## Features

### User Features

- Register/Login using email, password, and phone
- Location-based service requests (Google Maps integration)
- Request services by category and service
- View and compare offers from multiple providers
- Contact providers directly via phone
- Rate service providers after job completion
- View and manage previous requests
- Cancel service requests in ‘Pending’ status

### Service Provider Features

- Register with national ID, selfie, location, and police clearance
- Secure login and profile management
- View nearby service requests in their registered category
- Submit offers
- Mark service requests as completed upon job fulfillment

---

## Installation

1. **Clone the repository**

```bash
git clone https://github.com/KarimYasser15/kafa2a
cd kafa2a
```

2. **Install dependencies**

```bash
flutter pub get
```

3. **Run the app**

```bash
flutter run
```

---

## Folder Structure

```text
lib/
├── core/                            # Common utilities, constants, error handling
│   ├── error/                       # Error handling classes
│   ├── utils/                       # Utilities (formatters, validators, location access)
│   └── widgets/                     # Shared widgets (buttons, loaders, etc.)
│
├── config/                          # App-level configuration
│   ├── routes_manager.dart          # Named route configuration
│   └── app_theme.dart               # App theming
│
├── features/                        # Feature-based modular structure
│   └── auth/                        # Authentication module
│       ├── data/                    # Data layer: remote/local sources, models, mappers
│       │   ├── datasources/         # API or local storage sources
│       │   ├── mappers/             # Model-to-entity converters
│       │   ├── models/              # DTOs used in the data layer
│       │   └── repositories/        # Implementation of domain repositories
│       │
│       ├── domain/                  # Domain layer: entities, use cases, contracts
│       │   ├── entities/            # Business entities (pure Dart classes)
│       │   ├── repositories/        # Abstract repository contracts
│       │   └── use_cases/            # Business logic (e.g., login, register)
│       │
│       └── presentation/            # UI + state management
│           ├── cubit/               # Cubits and states
│           ├── screens/             # UI screens/pages
│           └── widgets/             # UI components (forms, inputs, etc.)
│
└── main.dart                        # App entry point (includes DI initialization)

```
