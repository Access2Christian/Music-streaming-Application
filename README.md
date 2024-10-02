
# Music Streaming App

## Project Structure

```plaintext
music_streaming_app/
│
├── backend/
│   ├── api/
│   ├── migrations/
│   ├── music_app/
│   ├── users/
│   ├── db.sqlite
│   ├── manage.py
│   └── README.md
│
└── frontend/
    ├── models/
    ├── screens/
    ├── services/
    ├── widgets/
    ├── main.dart
    ├── analysis_options.yaml
    ├── pubspec.lock
    ├── pubspec.yaml
    └── README.md
```

## Backend

### Description
The backend is responsible for handling data management, user authentication, and serving API endpoints for the music streaming application.

### Directory Structure
- **api/**: Contains the code for API endpoints and related logic.
- **migrations/**: Database migrations for schema changes.
- **music_app/**: Main application logic for the music app.
- **users/**: User authentication and management logic.
- **db.sqlite**: SQLite database file.
- **manage.py**: Command-line utility for managing the Django project.
- **README.md**: Documentation for the backend.

## Frontend

### Description
The frontend is a Flutter application that provides a user interface for the music streaming app.

### Directory Structure
- **models/**: Contains data models used in the app.
- **screens/**: Contains different screens of the application (e.g., Home, Login, Register, Now Playing).
- **services/**: Contains services for making API calls and other business logic.
- **widgets/**: Contains reusable UI components.
- **main.dart**: The entry point of the Flutter application.
- **analysis_options.yaml**: Configuration for Dart analysis.
- **pubspec.lock**: Dependency lock file.
- **pubspec.yaml**: Configuration file for dependencies and project metadata.
- **README.md**: Documentation for the frontend.

## Getting Started

### Prerequisites
- Python 3.x
- Django
- Flutter
- Dart

### Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/yourusername/music_streaming_app.git
   cd music_streaming_app
   ```

2. Set up the backend:

   ```bash
   cd backend
   python manage.py migrate  # Run database migrations
   python manage.py runserver  # Start the Django server
   ```

3. Set up the frontend:

   ```bash
   cd frontend
   flutter pub get  # Get Flutter dependencies
   flutter run  # Start the Flutter app
   ```

### Usage
- Access the backend API at `http://127.0.0.1:8000/api/`
- Use the Flutter application to register, log in, and stream music.

## Contributing
Contributions are welcome! Please submit a pull request or open an issue.

## License
This project is licensed under the MIT License. See the LICENSE file for details.
