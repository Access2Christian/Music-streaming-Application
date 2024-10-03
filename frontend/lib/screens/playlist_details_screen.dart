import 'package:flutter/material.dart';
import '../models/playlist.dart';
import 'now_playing_screen.dart';

class PlaylistDetailsScreen extends StatelessWidget {
  final Playlist playlist; // Playlist object to display

  const PlaylistDetailsScreen({Key? key, required this.playlist}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECEFF1), // Light gray background
      appBar: AppBar(
        title: Text(playlist.name), // Displays playlist name in AppBar
        backgroundColor: const Color(0xFF4A90E2), // Soft blue AppBar color
      ),
      body: playlist.songs.isEmpty
          ? const Center(
              child: Text(
                "No songs in this playlist.", // Message if no songs are in the playlist
                style: TextStyle(color: Color(0xFF5A4D3A)), // Slightly darker tone text
              ),
            )
          : ListView.separated(
              itemCount: playlist.songs.length, // Number of songs in playlist
              separatorBuilder: (context, index) => const Divider(
                height: 20,
                color: Color(0xFFC8B591), // Beige divider between songs
              ),
              itemBuilder: (context, index) {
                final song = playlist.songs[index]; // Retrieves each song
                return ListTile(
                  title: Text(
                    song.title, // Song title
                    style: const TextStyle(color: Color(0xFF5A4D3A)), // Slightly darker tone for song title
                  ),
                  subtitle: Text(
                    song.artist, // Song artist
                    style: const TextStyle(color: Color(0xFF4A90E2)), // Soft blue for artist name
                  ),
                  leading: song.albumCoverUrl != null
                      ? ClipOval(
                          child: Image.network(
                            song.albumCoverUrl!, // Album cover image
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.music_note,
                                size: 50,
                                color: Color(0xFF4A90E2), // Soft blue for error fallback icon
                              );
                            },
                          ),
                        )
                      : const Icon(
                          Icons.music_note,
                          size: 50,
                          color: Color(0xFF4A90E2), // Default icon if no album cover
                        ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NowPlayingScreen(music: song), // Navigates to the Now Playing screen with the selected song
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
