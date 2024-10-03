import 'package:flutter/material.dart';
import '../models/playlist.dart';
import '../services/api_service.dart';
import 'playlist_details_screen.dart';

class PlaylistScreen extends StatefulWidget {
  const PlaylistScreen({super.key});

  @override
  _PlaylistScreenState createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  List<Playlist> playlists = []; // List to hold the fetched playlists
  bool isLoading = true; // Loading state indicator
  String errorMessage = ''; // Error message to display

  @override
  void initState() {
    super.initState();
    fetchPlaylists(); // Fetch playlists on screen initialization
  }

  /// Fetches playlists from the API and updates the UI accordingly.
  Future<void> fetchPlaylists() async {
    setState(() {
      isLoading = true; // Set loading state to true
      errorMessage = ''; // Reset error message
    });

    try {
      List<Playlist> fetchedPlaylists = await ApiService.fetchPlaylists(); // Fetch playlists from API
      setState(() {
        playlists = fetchedPlaylists; // Update playlists list
      });
    } catch (error) {
      setState(() {
        errorMessage = 'Failed to load playlists: $error'; // Set error message if fetching fails
      });
    } finally {
      setState(() {
        isLoading = false; // Stop loading spinner
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECEFF1), // Light gray background
      appBar: AppBar(
        title: const Text("Your Playlists"), // App title
        backgroundColor: const Color(0xFF4A90E2), // Soft blue AppBar
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh), // Refresh icon
            onPressed: fetchPlaylists, // Refresh playlists on tap
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: fetchPlaylists, // Enable pull-to-refresh
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF4A90E2), // Soft blue loading spinner
                ),
              )
            : errorMessage.isNotEmpty
                ? _buildErrorWidget() // Build error widget if there is an error
                : playlists.isEmpty
                    ? _buildEmptyState() // Build empty state if playlists are empty
                    : _buildPlaylistList(), // Build playlist list if data is available
      ),
    );
  }

  /// Builds a widget to display the error message and a retry button.
  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            errorMessage, // Display error message
            style: const TextStyle(color: Colors.red), // Style for error message
          ),
          const SizedBox(height: 10), // Space between elements
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4A90E2), // Soft blue retry button
              foregroundColor: Colors.white, // Set button text color to white for visibility
            ),
            onPressed: fetchPlaylists, // Retry fetching playlists
            child: const Text("Retry"), // Retry button text
          ),
        ],
      ),
    );
  }

  /// Builds a widget to display when there are no playlists available.
  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.playlist_add,
            size: 80, // Size of the icon
            color: Color(0xFF4A90E2), // Soft blue icon color
          ),
          SizedBox(height: 10), // Space between elements
          Text(
            "No playlists available", // Message for empty state
            style: TextStyle(
              fontSize: 18,
              color: Color(0xFF5A4D3A), // Slightly darker tone for text
            ),
          ),
        ],
      ),
    );
  }

  /// Builds a list of playlists.
  Widget _buildPlaylistList() {
    return ListView.builder(
      itemCount: playlists.length, // Number of playlists to display
      itemBuilder: (context, index) {
        return Card(
          color: const Color(0xFFF0F4F8), // Light gray card color
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0), // Card margins
          elevation: 2, // Elevation for shadow effect
          child: ListTile(
            title: Text(
              playlists[index].name, // Playlist name
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF5A4D3A), // Slightly darker tone for playlist name
              ),
            ),
            subtitle: Text(
              "${playlists[index].songs.length} songs", // Number of songs in playlist
              style: const TextStyle(color: Color(0xFF4A90E2)), // Soft blue for song count
            ),
            leading: const Icon(
              Icons.playlist_play,
              color: Color(0xFF4A90E2), // Soft blue playlist icon
            ),
            onTap: () {
              // Navigate to playlist details on tap
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PlaylistDetailsScreen(playlist: playlists[index]), // Navigate to playlist details
                ),
              );
            },
          ),
        );
      },
    );
  }
}
