# Products Cart

A Flutter e-commerce app that displays products from an external API, with cart and favorites support backed by local storage, built on Clean Architecture.

## Architecture

The project follows **Clean Architecture**, split into features, each divided into 3 layers:

- **Domain** — Entities, Repositories (abstract), Usecases — pure business logic with no external dependencies.
- **Data** — Models, Data Sources (Local/Remote), Repository implementations — actual data fetching and storage.
- **Presentation** — Cubit/State (BLoC), Screens, Widgets — UI and state management.

```
lib/
├── app/                  # Root screen entry point
├── core/                 # Code shared across all features
│   ├── constants/
│   ├── database/         # SQLite database setup
│   ├── di/               # Dependency injection container (get_it)
│   ├── error/             # Exceptions / Failures
│   ├── network/           # Dio setup + connectivity check
│   ├── theme/
│   ├── usecase/
│   └── widgets/
└── features/
    ├── product/          # Product listing and details
    ├── cart/             # Shopping cart
    └── favorite/         # Favorites
```

## Tech Stack

### Core
- **[Flutter](https://flutter.dev)** — application framework (SDK ^3.11.5).
- **[Dart](https://dart.dev)** — programming language.

### State Management
- **[flutter_bloc](https://pub.dev/packages/flutter_bloc)** (`^9.0.0`) — Cubit/BLoC pattern for managing state per feature.
- **[equatable](https://pub.dev/packages/equatable)** (`^2.0.5`) — value equality for states and entities.
- **[freezed_annotation](https://pub.dev/packages/freezed_annotation)** / **[freezed](https://pub.dev/packages/freezed)** (`^3.x`) — code-generated immutable state classes.

### Dependency Injection
- **[get_it](https://pub.dev/packages/get_it)** (`^8.0.3`) — service locator for repositories, data sources, and cubits.

### Networking
- **[dio](https://pub.dev/packages/dio)** (`^5.7.0`) — HTTP client for API calls.
- **API**: [FakeStore API](https://fakestoreapi.com) — product data source.
- **[connectivity_plus](https://pub.dev/packages/connectivity_plus)** (`^7.2.0`) — checks network availability before making requests.

### Functional Error Handling
- **[dartz](https://pub.dev/packages/dartz)** (`^0.10.1`) — `Either<Failure, Success>` instead of throwing exceptions, for explicit error flow across Domain/Data layers.

### Local Persistence
- **[sqflite](https://pub.dev/packages/sqflite)** (`^2.4.1`) — SQLite database for storing cart items.
- **[path](https://pub.dev/packages/path)** (`^1.9.0`) — building database file paths.
- **[shared_preferences](https://pub.dev/packages/shared_preferences)** (`^2.3.4`) — key-value storage for favorites.

### UI
- **[flutter_screenutil](https://pub.dev/packages/flutter_screenutil)** (`^5.9.3`) — responsive UI scaling across screen sizes.
- Material Design (via a custom `AppTheme`).

### Dev Tools
- **[build_runner](https://pub.dev/packages/build_runner)** (`^2.15.1`) — runs code generation for freezed.
## Features

- 🛍️ **Product listing** — browse products and view product details, fetched from FakeStore API.
- 🛒 **Cart** — add/remove products, adjust quantity, persisted locally via SQLite.
- ❤️ **Favorites** — mark products as favorite, persisted locally.
- 📶 **Offline awareness** — checks network status before making requests via `connectivity_plus`.
- 📱 **Responsive UI** — via `flutter_screenutil`.

## Getting Started

```bash
# install dependencies
flutter pub get

# run code generation (freezed) when needed
dart run build_runner build --delete-conflicting-outputs

# run the app
flutter run
```

## Supported Platforms

Android, iOS, Web, Windows, macOS, Linux (via Flutter's standard multi-platform structure).
