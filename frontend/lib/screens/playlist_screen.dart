import 'package:flutter/material.dart';
import '../models/playlist.dart'; // Import the Playlist model
import '../services/api_service.dart'; // Import the API service to fetch playlists
import 'playlist_details_screen.dart'; // Import the playlist details screen

/// This screen displays a list of playlists fetched from an API.
class PlaylistScreen extends StatefulWidget {
  const PlaylistScreen({super.key}); // Constructor with an optional key

  @override
  PlaylistScreenState createState() => PlaylistScreenState(); // Create the state for PlaylistScreen
}

class PlaylistScreenState extends State<PlaylistScreen> {
  List<Playlist> playlists = []; // List to hold the fetched playlists
  bool isLoading = true; // Loading state to indicate when data is being fetched
  String errorMessage = ''; // Error message for API call failures

  @override
  void initState() {
    super.initState();
    fetchPlaylists(); // Fetch playlists on screen initialization
  }

  /// Fetches playlists from the API and updates the UI accordingly.
  Future<void> fetchPlaylists() async {
    setState(() {
      isLoading = true; // Set loading state to true while fetching
      errorMessage = ''; // Reset any previous error message
    });

    try {
      // Attempt to fetch the playlists from the API
     List<Playlist> fetchedPlaylists = await ApiService.fetchPlaylists() as List<Playlist>;
      setState(() {
        playlists = fetchedPlaylists; // Update the playlists with fetched data
      });
    } catch (error) {
      // Handle any errors during API call
      setState(() {
        errorMessage = 'Failed to load playlists: $error'; // Set error message for display
      });
    } finally {
      // Whether success or error, stop the loading spinner
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECEFF1), // Light gray background
      appBar: AppBar(
        title: const Text("Your Playlists"), // Title displayed in the AppBar
        backgroundColor: const Color(0xFF4A90E2), // Soft blue background color for the AppBar
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh), // Refresh icon button in the AppBar
            onPressed: fetchPlaylists, // Fetch playlists again when refresh is pressed
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: fetchPlaylists, // Enable pull-to-refresh functionality
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF4A90E2), // Loading spinner with blue color
                ),
              )
            : errorMessage.isNotEmpty
                ? _buildErrorWidget() // Show error widget if there is an error
                : playlists.isEmpty
                    ? _buildEmptyState() // Show empty state if there are no playlists
                    : _buildPlaylistList(), // Display the list of playlists if data is available
      ),
    );
  }

  /// Builds a widget to display an error message and a retry button.
  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Center the contents vertically
        children: [
          Text(
            errorMessage, // Display the error message
            style: const TextStyle(color: Colors.red), // Style the error message in red
          ),
          const SizedBox(height: 10), // Space between the error message and button
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4A90E2), // Soft blue background for the button
              foregroundColor: Colors.white, // White text color for the button
            ),
            onPressed: fetchPlaylists, // Retry fetching playlists when the button is pressed
            child: const Text("Retry"), // Button text
          ),
        ],
      ),
    );
  }

  /// Builds a widget to display when there are no playlists available.
  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Center the contents vertically
        children: [
          Icon(
            Icons.playlist_add,
            size: 80, // Large icon for empty state
            color: Color(0xFF4A90E2), // Soft blue color for the icon
          ),
          SizedBox(height: 10), // Space between the icon and text
          Text(
            "No playlists available", // Message displayed when no playlists exist
            style: TextStyle(
              fontSize: 18, // Font size for the message
              color: Color(0xFF5A4D3A), // Slightly darker tone for the text
            ),
          ),
        ],
      ),
    );
  }

  /// Builds a list of playlists, each as a card with playlist details.
  Widget _buildPlaylistList() {
    return ListView.builder(
      itemCount: playlists.length, // Number of playlists to display
      itemBuilder: (context, index) {
        return Card(
          color: const Color(0xFFF0F4F8), // Light gray card background color
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0), // Padding for each card
          elevation: 2, // Elevation for shadow effect
          child: ListTile(
            title: Text(
              playlists[index].name, // Playlist name as the title
              style: const TextStyle(
                fontWeight: FontWeight.bold, // Bold text for the title
                color: Color(0xFF5A4D3A), // Darker text color for readability
              ),
            ),
            subtitle: Text(
              "${playlists[index].songs.length} songs", // Display the number of songs in the playlist
              style: const TextStyle(color: Color(0xFF4A90E2)), // Soft blue text for subtitle
            ),
            leading: const Icon(
              Icons.playlist_play, // Playlist icon
              color: Color(0xFF4A90E2), // Soft blue icon color
            ),
            onTap: () {
              // Navigate to playlist details screen when tapped
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PlaylistDetailsScreen(playlist: playlists[index]), // Pass playlist data
                ),
              );
            },
          ),
        );
      },
    );
  }
}
