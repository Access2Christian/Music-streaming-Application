
# Frontend - Music Streaming App

## Project Structure

```plaintext
music_streaming_app/
├── android/
├── ios/
├── lib/
│   ├── main.dart
│   ├── screens/
│   │   ├── home_screen.dart         # Home screen of the app
│   │   ├── login_screen.dart        # User login screen
│   │   ├── register_screen.dart     # User registration screen
│   │   ├── now_playing_screen.dart  # Now Playing screen for currently playing music
│   │   ├── playlist_screen.dart      # Screen displaying user's playlists
│   │   ├── playlist_details_screen.dart # Detailed view of a selected playlist
│   │   ├── profile_screen.dart       # User profile screen
│   │   └── settings_screen.dart      # App settings screen
│   ├── widgets/
│   │   ├── music_card.dart           # Widget for displaying music information
│   │   └── search_field.dart         # Search input field widget
│   ├── models/
│   │   └── music.dart                # Data model for music
│   └── services/
│       └── music_service.dart        # Service for making API calls related to music
├── pubspec.yaml
└── README.md
```

## Description
The frontend is a Flutter application that provides a user interface for the music streaming app. Users can log in, register, browse music, manage playlists, and customize settings.

## Screens Overview
- **Home Screen**: Displays featured music and navigation to other parts of the app.
- **Login Screen**: Allows users to authenticate with their credentials.
- **Register Screen**: Enables new users to create an account.
- **Now Playing Screen**: Shows details of the currently playing track.
- **Playlist Screen**: Lists all user-created playlists.
- **Playlist Details Screen**: Displays tracks within a selected playlist.
- **Profile Screen**: User can view and edit their profile information.
- **Settings Screen**: Provides options for app settings and preferences.

## Getting Started

### Prerequisites
- Flutter
- Dart

### Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/Access2Christian/Music-streaming-Application.git
   cd frontend
   ```

2. Install dependencies:

   ```bash
   flutter pub get
   ```

3. Run the application:

   ```bash
   flutter run
   ```

## Usage
- Use the Flutter application to register, log in, and stream music.
- Navigate through different screens to access various features of the app.

## Contributing
Contributions are welcome! Please submit a pull request or open an issue.

## License
This project is licensed under the MIT License. See the LICENSE file for details.

