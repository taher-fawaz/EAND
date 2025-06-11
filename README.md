# GitHub Repositories Viewer App

## Overview
This application is a native Android (Kotlin) app that integrates a Flutter module to display GitHub user's public repositories. The app fetches data from the GitHub API in the Flutter module, implements lazy loading for commits, and includes a data persistence layer in Flutter.

## Project Structure
This is a monorepo containing both the native Android project and the Flutter module:

- `EAND Android/` - Native Android application written in Kotlin using Jetpack Compose
- `eand_flutter/` - Flutter module for displaying GitHub repositories

## Architecture

### Native Android App
- **Architecture Pattern**: Clean Architecture with MVVM
- **UI Framework**: Jetpack Compose
- **Key Components**:
  - Presentation Layer: ViewModels, Compose UI
  - Domain Layer: Use Cases, Repository Interfaces
  - Data Layer: Repository Implementations, Data Sources

### Flutter Module
- **Architecture Pattern**: MVVM with BLoC (Business Logic Component)
- **Key Components**:
  - Presentation Layer: Widgets, BLoC
  - Domain Layer: Repositories, Entities
  - Data Layer: Data Sources, Models

## Features

### Native Initial Screen
- Header displaying "GITHUB" (centered)
- "Show Repos" button to launch the Flutter module
- Display of selected repository data (name, image, description)
- List of commits for the selected repository

### Flutter Screens

#### Repository List Screen
- Horizontal list view (first 5 repositories) with infinite circular scrolling
- Vertical list view (remaining repositories)
- Lazy loading of commits for visible repositories
- Display of the last 3 commits per repository in an expandable card

#### Repository Detail Bottom Sheet
- Bottom sheet overlay displaying repository details
- Header with repository name
- Close button
- Repository data (name, image, description)
- "Select Repo" button to return data to native UI

### Data Persistence
- Local database storage using HiveDB
- Offline mode support
- Pull-to-refresh for fetching fresh data when online

## Setup Instructions

### Prerequisites
- Android Studio Arctic Fox or later
- Flutter SDK 3.0.0 or later
- Kotlin 1.7.0 or later
- Java 11 or later
- Git

### Installation

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd EAND
   ```

2. Open the Android project in Android Studio:
   - Open Android Studio
   - Select "Open an existing Android Studio project"
   - Navigate to the `EAND Android` directory and click "Open"

3. Set up the Flutter module:
   ```bash
   cd eand_flutter
   flutter pub get
   ```

4. Run the app:
   - Connect an Android device or start an emulator
   - In Android Studio, click the "Run" button

## API Integration

The app integrates with the following GitHub API endpoints:

- Repository List: `https://api.github.com/users/mralexgray/repos`
- Repository Commits: `https://api.github.com/repos/{owner}/{repo}/commits`

## Testing

The project includes comprehensive unit tests for both the Android and Flutter components:

### Android Tests
```bash
./gradlew test
```

### Flutter Tests
```bash
cd eand_flutter
flutter test
```

## Code Coverage

### Flutter Coverage
```bash
cd eand_flutter
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```
The report will be generated at `eand_flutter/coverage/html/index.html`

## Project Requirements

- Clean Architecture implementation
- Lazy loading and circular scrolling
- Functional data persistence layer
- Unit tests and code coverage
- UI/UX matching the provided wireframes

## License

This project is licensed under the MIT License - see the LICENSE file for details.