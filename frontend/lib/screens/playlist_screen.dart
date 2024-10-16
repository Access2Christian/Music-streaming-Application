import 'package:flutter/material.dart';
import '../models/playlist.dart'; // Import the Playlist model to represent a playlist
import '../services/api_service.dart'; // Import the API service to fetch playlists from a backend
import 'now_playing_screen.dart'; // Import the screen for displaying currently playing music

class PlaylistScreen extends StatefulWidget {
  const PlaylistScreen({super.key}); // Constructor with an optional key to maintain widget state

  @override
  PlaylistScreenState createState() => PlaylistScreenState(); // Create state for PlaylistScreen
}

class PlaylistScreenState extends State<PlaylistScreen> {
  List<Playlist> playlists = []; // List to hold the fetched playlists
  bool isLoading = true; // Loading state to indicate when playlists are being fetched
  String errorMessage = ''; // Error message for API call failures

  @override
  void initState() {
    super.initState();
    fetchPlaylists(); // Fetch playlists when the screen is initialized
  }

  /// Fetches playlists from the API and updates the UI based on the result.
  Future<void> fetchPlaylists() async {
    setState(() {
      isLoading = true; // Set loading to true while data is being fetched
      errorMessage = ''; // Clear any previous error messages
    });

    try {
      // Fetch playlists from the API service
      List<Playlist> fetchedPlaylists = await ApiService.fetchPlaylists() as List<Playlist>;
      setState(() {
        playlists = fetchedPlaylists; // Update the state with the fetched playlists
      });
    } catch (error) {
      // If an error occurs, display it on the screen
      setState(() {
        errorMessage = 'Failed to load playlists: $error'; // Show error message
      });
    } finally {
      // Stop the loading spinner after fetching data
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECEFF1), // Set a light gray background color for the screen
      appBar: AppBar(
        title: const Text("Playlists"), // Title for the AppBar
        backgroundColor: const Color(0xFF4A90E2), // Soft blue color for the AppBar
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh), // Icon for refreshing the playlist list
            onPressed: fetchPlaylists, // Fetch playlists again when refresh is tapped
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: fetchPlaylists, // Enable pull-to-refresh functionality
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF4A90E2), // Blue color for the loading spinner
                ),
              )
            : errorMessage.isNotEmpty
                ? _buildErrorWidget() // Show error widget if an error occurred
                : playlists.isEmpty
                    ? _buildEmptyState() // Show empty state if no playlists are available
                    : _buildPlaylistList(), // Show the list of playlists if they exist
      ),
    );
  }

  /// Builds a widget to display when an error occurs (e.g., failed API call).
  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Center the error widget
        children: [
          Text(
            errorMessage, // Display the error message
            style: const TextStyle(color: Colors.red), // Style the error message in red
          ),
          const SizedBox(height: 10), // Add space between error message and retry button
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4A90E2), // Blue button color
              foregroundColor: Colors.white, // White text color for button
            ),
            onPressed: fetchPlaylists, // Retry fetching playlists when the button is pressed
            child: const Text("Retry"), // Button text
          ),
        ],
      ),
    );
  }

  /// Builds a widget to display when no playlists are available.
  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Center the empty state widget
        children: [
          Icon(
            Icons.playlist_add, // Icon for an empty playlist
            size: 80, // Set the size of the icon
            color: Color(0xFF4A90E2), // Set the color of the icon to blue
          ),
          SizedBox(height: 10), // Add space between the icon and the message
          Text(
            "No playlists available", // Message when no playlists are available
            style: TextStyle(
              fontSize: 18, // Font size for the message
              color: Color(0xFF5A4D3A), // Set the text color
            ),
          ),
        ],
      ),
    );
  }

  /// Builds a widget to display the list of playlists.
  Widget _buildPlaylistList() {
    return ListView.builder(
      itemCount: playlists.length, // Number of playlists to display
      itemBuilder: (context, index) {
        return Card(
          color: const Color(0xFFF0F4F8), // Set the background color for the playlist cards
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0), // Margin between cards
          elevation: 2, // Add a shadow effect to the cards
          child: ListTile(
            title: Text(
              playlists[index].name, // Display the playlist name
              style: const TextStyle(
                fontWeight: FontWeight.bold, // Set the playlist name as bold
                color: Color(0xFF5A4D3A), // Set the text color for playlist name
              ),
            ),
            subtitle: Text(
              "${playlists[index].songs.length} songs", // Display the number of songs in the playlist
              style: const TextStyle(color: Color(0xFF4A90E2)), // Set the subtitle text color to blue
            ),
            leading: const Icon(
              Icons.playlist_play, // Icon to represent playlist
              color: Color(0xFF4A90E2), // Set the icon color to blue
            ),
            onTap: () {
              // When a playlist is tapped, navigate to the NowPlayingScreen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NowPlayingScreen(
                    music: playlists[index].songs[0], // Pass the first song of the playlist
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
