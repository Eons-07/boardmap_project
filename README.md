# BoardMap

**BoardMap: A GIS-Based Machine Learning Boarding House Mapping and Recommendation System for Cabadbaran City**

## Summary
BoardMap centralizes the search, listing, and management of boarding houses, dormitories, and similar rentals in Cabadbaran City. It uses GIS mapping to show property locations and a K-Nearest Neighbors (KNN) recommendation engine to match seekers with suitable places by budget, distance, and amenities. Roles: Seeker, Owner, and Admin.

This first checkpoint contains the Flutter Web starter: a Login screen and a Home screen built from reusable widgets. Sign-in is simulated and the places shown are sample data until the REST API is built.

## Current stack
- Implemented: Flutter Web / Dart, Git and GitHub
- Planned (not built yet): FastAPI REST API, PostgreSQL + PostGIS, KNN recommendations (scikit-learn), Flutter packages such as Provider, http, and flutter_map

## Prerequisites
Flutter SDK, Google Chrome, and Git.

## Run locally
Run these from the project root (the folder that contains `pubspec.yaml`):

```
git clone https://github.com/Eons-07/boardmap_project.git
cd boardmap_project
flutter pub get
flutter run -d chrome
```

Run the widget tests with `flutter test`.

## Project structure
```
lib/
|-- main.dart          entry point
|-- app.dart           MaterialApp, theme, first screen
|-- screens/           login_screen.dart, home_screen.dart
|-- widgets/           app_button.dart, app_text_field.dart
|-- services/          future REST API clients
|-- models/            future data models
|-- routes/            future routing definitions
`-- constants/         app-wide constants (never store secrets)
```

## First checkpoint
Date: October 13, 2026 | Commit: de33f07
