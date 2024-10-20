
# Music Streaming App

A Flutter and Django-based music streaming application that allows users to register, log in, and stream music seamlessly. This project showcases the integration of front-end and back-end technologies to create a complete application.

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
The backend is responsible for data management, user authentication, and serving API endpoints for the music streaming application.

### Directory Structure
- **api/**: Contains the code for API endpoints and related logic.
- **migrations/**: Holds database migrations for schema changes.
- **music_app/**: Contains the main application logic for the music app.
- **users/**: Manages user authentication and profiles.
- **db.sqlite**: SQLite database file.
- **manage.py**: Command-line utility for managing the Django project.
- **README.md**: Documentation for the backend.

## Frontend

### Description
The frontend is a Flutter application that provides an intuitive user interface for the music streaming app.

### Directory Structure
- **models/**: Contains data models used in the app.
- **screens/**: Contains the different screens of the application (e.g., Home, Login, Register, Now Playing).
- **services/**: Manages API calls and other business logic.
- **widgets/**: Reusable UI components.
- **main.dart**: Entry point of the Flutter application.
- **analysis_options.yaml**: Configuration for Dart analysis.
- **pubspec.lock**: Dependency lock file.
- **pubspec.yaml**: Project metadata and dependencies configuration.
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
   git clone https://github.com/Access2Christian/Music-streaming-Application.git
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
- Access the backend API at `http://127.0.0.1:8000/api/`.
- Use the Flutter application to register, log in, and stream music.

## Objectives
- Develop a full-stack application using Flutter for the frontend and Django for the backend.
- Implement user authentication and manage data securely.
- Integrate external APIs for dynamic content delivery.

## Challenges Faced
- Dealing with CORS issues while connecting the frontend and backend.
- Handling authentication and token management for secure API access.
- Ensuring smooth data flow between the frontend and backend components.

## Lessons Learned
- Gained hands-on experience with RESTful APIs and authentication mechanisms.
- Improved my skills in Flutter and Django frameworks.
- Developed better problem-solving skills by troubleshooting various issues during the development process.

## Contributing
Contributions are welcome! To contribute, please follow these steps:
1. Fork the repository.
2. Create a new branch for your feature or bug fix.
3. Make your changes and commit them.
4. Submit a pull request.

## License
This project is licensed under the MIT License. See the [LICENSE](./LICENSE) file for details.

## Acknowledgements
- Thanks to the Django and Flutter communities for their invaluable resources and support.
- Special thanks to the API services used for music streaming data.
