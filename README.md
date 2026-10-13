# BoardMap

## Summary
BoardMap is a web-based system that helps people find and compare boarding places such as rooms, apartments, and dormitories. Users sign in, browse a list of places, search by name or area, and filter by category. The first checkpoint contains the Flutter Web starter: a Login screen and a Home screen built from reusable widgets. Sign-in is simulated and the places shown are sample data until the REST API is built.

## Current stack
- Implemented: Flutter Web / Dart, Git and GitHub
- Planned (not built yet): REST API (instructor-approved backend) and PostgreSQL

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
