import 'package:flutter/material.dart';
import '../models/playlist.dart';
import '../services/api_service.dart';
import 'playlist_details_screen.dart'; // Import the details screen

class PlaylistScreen extends StatefulWidget {
  const PlaylistScreen({super.key});

  @override
  _PlaylistScreenState createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  List<Playlist> playlists = [];
  bool isLoading = true; // To track loading state
  String errorMessage = ''; // To store error messages

  @override
  void initState() {
    super.initState();
    fetchPlaylists(); // Fetch playlists on initialization
  }

  Future<void> fetchPlaylists() async {
    setState(() {
      isLoading = true; // Start loading
      errorMessage = ''; // Reset error message
    });

    try {
      List<Playlist> fetchedPlaylists = await ApiService.fetchPlaylists(); // Fetch playlists from the API
      setState(() {
        playlists = fetchedPlaylists; // Update the playlists list
      });
    } catch (error) {
      setState(() {
        errorMessage = 'Failed to load playlists: $error'; // Store error message
      });
    } finally {
      setState(() {
        isLoading = false; // Stop loading
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Playlists"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              fetchPlaylists(); // Refresh playlists
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: fetchPlaylists, // Pull to refresh
        child: isLoading
            ? const Center(child: CircularProgressIndicator()) // Loading indicator
            : errorMessage.isNotEmpty
                ? _buildErrorWidget() // Show error message widget
                : playlists.isEmpty
                    ? _buildEmptyState() // Show empty state widget
                    : _buildPlaylistList(), // Show the list of playlists
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(errorMessage, style: const TextStyle(color: Colors.red)), // Display error message
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: fetchPlaylists, // Retry fetching playlists
            child: const Text("Retry"),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.playlist_add, size: 80, color: Colors.grey), // Empty state icon
          SizedBox(height: 10),
          Text("No playlists available", style: TextStyle(fontSize: 18)), // Message for empty playlists
        ],
      ),
    );
  }

  Widget _buildPlaylistList() {
    return ListView.builder(
      itemCount: playlists.length,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
          elevation: 2,
          child: ListTile(
            title: Text(
              playlists[index].name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text("${playlists[index].songs.length} songs"), // Number of songs in the playlist
            leading: const Icon(Icons.playlist_play), // Placeholder icon for playlists
            onTap: () {
              // Navigate to playlist details
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PlaylistDetailsScreen(playlist: playlists[index]), // Pass selected playlist to details screen
                ),
              );
            },
          ),
        );
      },
    );
  }
}
