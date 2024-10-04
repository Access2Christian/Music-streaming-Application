import 'package:flutter/material.dart';
import 'screens/home_screen.dart' as home; // Importing HomeScreen with an alias for clarity
import 'screens/register_screen.dart';
import 'screens/login_screen.dart' as login; // Importing LoginScreen with an alias for clarity
import 'screens/playlist_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/profile_screen.dart';
import 'models/music.dart';
import 'services/api_service.dart';
import 'widgets/search_field.dart';

void main() {
  runApp(const MyApp()); // Entry point of the app
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music Streaming App', // Title for the application
      theme: ThemeData(
        primaryColor: const Color(0xFF4A90E2), // Updated primary color to match the theme of the app
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF4A90E2), // Consistent primary color for light theme
          secondary: Color(0xFFC2B280), // Secondary color for accents
        ),
        scaffoldBackgroundColor: const Color(0xFFECEFF1), // Set the background color to light gray
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF4A90E2), // Headline color to match primary color
          ),
          bodyMedium: TextStyle(
            fontSize: 16,
            color: Color(0xFF6B5B3A), // Color for medium body text
          ),
          bodySmall: TextStyle(
            color: Color(0xFF4A90E2), // Color for small body text
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: const MainScreen(), // Set the main screen of the app
      debugShowCheckedModeBanner: false, // Disable the debug banner
      routes: {
        '/home': (context) => home.HomeScreen(categorizedMusic: const {}, onPlay: (music) {}), // HomeScreen route
        '/login': (context) => const login.LoginScreen(), // LoginScreen route
        '/register': (context) => const RegisterScreen(), // RegisterScreen route
        '/playlist': (context) => const PlaylistScreen(), // PlaylistScreen route
        '/settings': (context) => const SettingsScreen(), // SettingsScreen route
        '/profile': (context) => const ProfileScreen(), // ProfileScreen route
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0; // To track the current index of the bottom navigation bar
  late Future<List<Music>> _musicList; // To hold the future music list
  String _searchQuery = ''; // To hold the current search query

  @override
  void initState() {
    super.initState();
    _musicList = ApiService.fetchMusic(); // Fetch music data when the widget is initialized
  }

  void _onNavItemTapped(int index) {
    setState(() {
      _currentIndex = index; // Update the current index based on user selection
      if (index == 0) {
        Navigator.pushNamed(context, '/home'); // Navigate to HomeScreen
      }
    });
  }

  void _handleSearch(String query) {
    setState(() {
      _searchQuery = query; // Update the search query and rebuild the UI
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Music Streaming App'), // Title of the app bar
        actions: [
          // Adding a menu for navigation to Login, Register, and Settings
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              switch (value) {
                case 'Login':
                  Navigator.pushNamed(context, '/login'); // Navigate to Login
                  break;
                case 'Register':
                  Navigator.pushNamed(context, '/register'); // Navigate to Register
                  break;
                case 'Settings':
                  Navigator.pushNamed(context, '/settings'); // Navigate to Settings
                  break;
              }
            },
            itemBuilder: (BuildContext context) {
              return {'Login', 'Register', 'Settings'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(
                    choice,
                    style: const TextStyle(fontSize: 14), // Style for menu items
                  ),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          SearchField(
            onSearch: _handleSearch, // Pass the search handler
          ),
          Expanded(
            child: _currentIndex == 0
                ? FutureBuilder<List<Music>>(
                    future: _musicList, // Future to fetch the music list
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator()); // Show loading indicator while fetching data
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.error, color: Colors.red, size: 50), // Error icon
                              const SizedBox(height: 16),
                              Text(
                                'Error fetching music: ${snapshot.error}', // Display error message
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _musicList = ApiService.fetchMusic(); // Retry fetching music
                                  });
                                },
                                child: const Text('Retry'), // Button to retry fetching music
                              ),
                            ],
                          ),
                        );
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text('No music available.')); // Message for no music data
                      } else {
                        // Filter the music based on the search query
                        List<Music> filteredMusic = snapshot.data!
                            .where((music) =>
                                music.title.toLowerCase().contains(_searchQuery.toLowerCase())) // Filtering logic
                            .toList();
                        return home.HomeScreen(
                          categorizedMusic: {'All Music': filteredMusic}, // Pass categorized music to HomeScreen
                          onPlay: (music) {
                            print('Playing ${music.title} by ${music.artist}'); // Handle music play action
                          },
                        );
                      }
                    },
                  )
                : _currentIndex == 1
                    ? const Center(child: Text('Now Playing')) // Placeholder for Now Playing screen
                    : _currentIndex == 2
                        ? const PlaylistScreen() // Navigate to Playlist screen
                        : const SettingsScreen(), // Navigate to Settings screen
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home), // Icon for Home tab
            label: 'Home', // Label for Home tab
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.play_arrow), // Icon for Now Playing tab
            label: 'Now Playing', // Label for Now Playing tab
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.playlist_play), // Icon for Playlist tab
            label: 'Playlist', // Label for Playlist tab
          ),
        ],
        currentIndex: _currentIndex, // Current index for BottomNavigationBar
        onTap: _onNavItemTapped, // Handle tap events on the navigation items
      ),
    );
  }
}
