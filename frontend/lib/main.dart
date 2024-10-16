import 'package:flutter/material.dart'; // Importing Flutter's material design framework
import 'package:logger/logger.dart'; // Importing logger package for debugging purposes
import 'screens/home_screen.dart' as home; // Alias import for HomeScreen widget
import 'screens/register_screen.dart'; // Importing RegisterScreen widget
import 'screens/login_screen.dart' as login; // Alias import for LoginScreen widget
import 'screens/now_playing_screen.dart'; // importing Now_Playing screen widget
import 'screens/playlist_screen.dart'; // Importing PlaylistScreen widget
import 'screens/settings_screen.dart'; // Importing SettingsScreen widget
import 'screens/profile_screen.dart'; // Importing ProfileScreen widget
import 'models/music.dart'; // Importing the Music model
import 'services/api_service.dart'; // Importing API service for fetching music data

// Entry point of the Flutter app
void main() {
  runApp(const MyApp()); // Launches the MyApp widget
}

// Root widget of the application
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key); // Constructor with an optional key parameter

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music Streaming App', // Sets the app's title
      theme: ThemeData(
        primaryColor: const Color(0xFF4A90E2), // Primary color used throughout the app
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF4A90E2), // Primary color for light theme
          secondary: Color(0xFF8C9EFF), // Secondary color used for accents
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F5F5), // Background color for screens
        appBarTheme: const AppBarTheme(
          elevation: 0, // No shadow for app bar
          backgroundColor: Colors.transparent, // Transparent app bar background
          iconTheme: IconThemeData(color: Color(0xFF4A90E2)), // Icon color for app bar
        ),
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            fontSize: 24, // Size of headline text
            fontWeight: FontWeight.bold, // Bold style for headlines
            color: Color(0xFF4A90E2), // Color for headlines
          ),
          bodyMedium: TextStyle(
            fontSize: 18, // Size of body text
            color: Color(0xFF6B5B3A), // Color for regular body text
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4A90E2), // Button background color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12), // Rounded corners for buttons
            ),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 28), // Button padding
            textStyle: const TextStyle(
              fontSize: 18, // Text size inside buttons
              fontWeight: FontWeight.bold, // Bold text inside buttons
              color: Colors.white, // White text color for contrast
            ),
          ),
        ),
      ),
      home: const MainScreen(), // Set MainScreen as the home screen of the app
      debugShowCheckedModeBanner: false, // Disable the debug banner in the top right
      routes: {
        '/home': (context) => home.HomeScreen(categorizedMusic: const {}, onPlay: (music) {}), // Home route
        '/login': (context) => const login.LoginScreen(), // Login screen route
        '/register': (context) => const RegisterScreen(), // Register screen route
        '/playlist': (context) => const PlaylistScreen(), // Playlist screen route
        '/settings': (context) => const SettingsScreen(), // Settings screen route
        '/profile': (context) => const ProfileScreen(), // Profile screen route
        
         // Modify the '/now_playing' route to handle the music argument
         '/now_playing': (context) {
          final music = ModalRoute.of(context)!.settings.arguments as Music;
          return NowPlayingScreen(music: music); // Pass the music object to the screen
        },
      },
    );
  }
}

// MainScreen is the initial widget users interact with
class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key); // Constructor for MainScreen

  @override
  MainScreenState createState() => MainScreenState(); // Create the state of MainScreen
}

// MainScreenState contains the state logic for the main screen
class MainScreenState extends State<MainScreen> {
  int _currentIndex = 0; // Tracks the current index of the bottom navigation bar
  late Future<List<Music>> _musicList; // Future to hold the list of music fetched from API
  String _searchQuery = ''; // Holds the user's search query
  final Logger logger = Logger(); // Logger instance for debugging

  @override
  void initState() {
    super.initState();
    // Initialize music list by fetching data from API on app start
    _musicList = ApiService.fetchShazamCharts();
  }

  // Method to retry fetching music
  void _retryFetchMusic() {
    setState(() {
      _musicList = ApiService.fetchShazamCharts(); // Retry fetching the music
      logger.i('Retrying to fetch music'); // Log retry attempt
    });
  }

  // Handles taps on the bottom navigation bar items
  void _onNavItemTapped(int index) {
  setState(() {
    _currentIndex = index; // Update the current index when a navigation item is tapped

    if (index == 0) {
      Navigator.pushNamed(context, '/home'); // Navigate to the home screen
    } else if (index == 1) {
      Navigator.pushNamed(context, '/playlist'); // Navigate to the playlist screen
    } else if (index == 2) {
      // Navigate to the now playing screen with a required 'music' argument
      final music = Music(title: 'Song Title', artist: 'Artist Name'); // Create a sample Music object
      Navigator.pushNamed(
        context,
        '/now_playing',
        arguments: music, // Pass the 'music' object as an argument
      );
    }
  });
}

  // Updates the search query when user types in the search bar
  void _handleSearch(String query) {
    setState(() {
      _searchQuery = query; // Update search query
      logger.i('Search query updated: $_searchQuery'); // Log the updated search query
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Music Streaming App'), // AppBar title
      ),
      drawer: _buildDrawer(), // Drawer for navigation
      body: Column(
        children: [
          _buildSearchBar(), // Search bar for music
          Expanded(
            child: _buildMusicList(), // FutureBuilder to display music list
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(), // Bottom navigation bar
    );
  }

  // Builds the navigation drawer
  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero, // Remove default padding
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFF4A90E2), // Drawer header background color
            ),
            child: Text(
              'Navigation Menu', // Drawer header text
              style: TextStyle(color: Colors.white, fontSize: 24), // Header text style
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home), // Icon for home navigation item
            title: const Text('Home'), // Home navigation label
            onTap: () {
              Navigator.pushNamed(context, '/home'); // Navigate to the home screen
            },
          ),
          ListTile(
            leading: const Icon(Icons.login), // Icon for login navigation item
            title: const Text('Login'), // Login navigation label
            onTap: () {
              Navigator.pushNamed(context, '/login'); // Navigate to the login screen
            },
          ),
          ListTile(
            leading: const Icon(Icons.person_add), // Icon for register navigation item
            title: const Text('Register'), // Register navigation label
            onTap: () {
              Navigator.pushNamed(context, '/register'); // Navigate to the register screen
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings), // Icon for settings navigation item
            title: const Text('Settings'), // Settings navigation label
            onTap: () {
              Navigator.pushNamed(context, '/settings'); // Navigate to the settings screen
            },
          ),
        ],
      ),
    );
  }

  // Builds the search bar
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0), // Padding for the search bar
      child: TextField(
        onChanged: _handleSearch, // Update search query when user types
        decoration: InputDecoration(
          hintText: 'Search your favorite music...', // Placeholder for search bar
          filled: true,
          fillColor: Colors.white, // Background color of search bar
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16), // Rounded corners for search bar
            borderSide: BorderSide.none, // No border for the search bar
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16), // Padding for input text
          suffixIcon: IconButton(
            icon: const Icon(Icons.search, color: Color(0xFF4A90E2)), // Search icon
            onPressed: () {}, // Empty function for search icon button
          ),
        ),
      ),
    );
  }

  // Builds the music list using FutureBuilder
Widget _buildMusicList() {
  return FutureBuilder<List<Music>>(
    future: _musicList, // Future to fetch music list
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator()); // Show loading spinner while waiting
      } else if (snapshot.hasError) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, color: Colors.red), // Error icon
              const SizedBox(height: 8), // Space between icon and text
              Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.red)), // Error message
              ElevatedButton(
                onPressed: _retryFetchMusic, // Retry button to fetch music again
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Background color of the button
                  foregroundColor: Colors.white, // Text color
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40, // Horizontal padding
                    vertical: 14.0, // Vertical padding
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0), // Rounded corners
                  ),
                ),
                child: const Text('Retry'), // Retry button label
              ),
            ],
          ),
        );
      } else {
        final musicList = snapshot.data!.where((music) => 
          music.title.toLowerCase().contains(_searchQuery.toLowerCase())
        ).toList(); // Filter music list based on search query

        if (musicList.isEmpty) {
          return const Center(child: Text('No music found')); // Message when no music matches the search
        }

        return ListView.builder(
          itemCount: musicList.length, // Total number of items in music list
          itemBuilder: (context, index) {
            final music = musicList[index]; // Get the music item
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(music.albumCoverUrl ?? ''), // Display music cover image
              ),
              title: Text(music.title), // Display music title
              subtitle: Text(music.artist), // Display music artist
              onTap: () {
                // Action when a music item is tapped
                logger.i('Playing: ${music.title}'); // Log the action
                // Play music action would go here
              },
            );
          },
        );
      }
    },
  );
}

  // Builds the bottom navigation bar
  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex, // Current index to highlight the active item
      onTap: _onNavItemTapped, // Handle tap on bottom navigation items
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home), // Home icon
          label: 'Home', // Home label
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.playlist_play), // Playlist icon
          label: 'Playlist', // Playlist label
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.play_arrow), // Now Playing icon
          label: 'Now Playing', // Now Playing label
        ),
      ],
    );
  }
}

