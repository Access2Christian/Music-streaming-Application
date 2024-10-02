import 'package:flutter/material.dart';
import '../models/playlist.dart'; // Ensure Playlist model is imported
import 'now_playing_screen.dart'; // Ensure NowPlayingScreen is imported

class PlaylistDetailsScreen extends StatelessWidget {
  final Playlist playlist;

  const PlaylistDetailsScreen({Key? key, required this.playlist}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(playlist.name), // Display playlist name in the app bar
      ),
      body: playlist.songs.isEmpty // Check if the playlist has no songs
          ? const Center(child: Text("No songs in this playlist.")) // Show message if empty
          : ListView.separated(
              itemCount: playlist.songs.length,
              separatorBuilder: (context, index) => const Divider(height: 20, color: Colors.grey), // Divider between songs
              itemBuilder: (context, index) {
                final song = playlist.songs[index]; // Get the current song
                return ListTile(
                  title: Text(song.title), // Display song title
                  subtitle: Text(song.artist), // Display song artist
                  leading: song.albumCoverUrl != null
                      ? ClipOval(
                          child: Image.network(
                            song.albumCoverUrl!,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.music_note, size: 50); // Fallback icon if image fails to load
                            },
                          ),
                        )
                      : const Icon(Icons.music_note, size: 50), // Default icon if no album cover
                  onTap: () {
                    // Navigate to NowPlayingScreen when a song is tapped
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NowPlayingScreen(music: song), // Pass the selected song
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}

