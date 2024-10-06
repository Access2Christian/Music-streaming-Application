import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../models/music.dart';

class MusicCard extends StatefulWidget {
  final Music music;
  final Function(Music) onPlay;

  const MusicCard({Key? key, required this.music, required this.onPlay}) : super(key: key);

  @override
  MusicCardState createState() => MusicCardState();
}

class MusicCardState extends State<MusicCard> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;
  bool isLoading = false; // To track loading state

  @override
  void dispose() {
    _audioPlayer.dispose(); // Clean up audio player
    super.dispose();
  }

  Future<void> _playMusic() async {
    setState(() {
      isLoading = true; // Start loading music
    });

    try {
      if (widget.music.audioUrl != null) {
        await _audioPlayer.play(UrlSource(widget.music.audioUrl!)); // Play the music
        setState(() {
          isPlaying = true; // Update playing state
        });
      } else {
        _showSnackBar('Audio URL is not available'); // Show error if URL is missing
      }
    } catch (error) {
      _showSnackBar('Error playing music: $error'); // Show error message
    } finally {
      setState(() {
        isLoading = false; // Stop loading
      });
    }
  }

  Future<void> _pauseMusic() async {
    await _audioPlayer.pause(); // Pause the audio
    setState(() {
      isPlaying = false; // Update playing state
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message))); // Show snackbar with message
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.onPlay(widget.music), // Trigger onPlay callback
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        decoration: BoxDecoration(
          color: const Color(0xFFE3F2FD), // Light gray background for card
          borderRadius: BorderRadius.circular(15), // Rounded corners
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2), // Subtle shadow
              blurRadius: 5,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image.network(
              widget.music.albumCoverUrl ?? '',
              fit: BoxFit.cover,
              width: 60,
              height: 60,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 60,
                  height: 60,
                  color: Colors.grey, // Placeholder for album cover
                  child: const Icon(Icons.music_note, color: Colors.white), // Fallback icon
                );
              },
            ),
          ),
          title: Text(
            widget.music.title,
            style: Theme.of(context).textTheme.titleLarge, // Title style
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.music.artist,
                style: Theme.of(context).textTheme.bodyLarge, // Artist style
              ),
              Text(
                _formatDuration(widget.music.duration),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey), // Duration style
              ),
            ],
          ),
          trailing: isLoading
              ? const CircularProgressIndicator() // Loading indicator
              : IconButton(
                  icon: Icon(
                    isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
                    color: const Color(0xFF4A90E2), // Soft blue icon color
                    size: 40, // Icon size
                  ),
                  onPressed: isPlaying ? _pauseMusic : _playMusic, // Play or pause action
                ),
        ),
      ),
    );
  }

  String _formatDuration(String? duration) {
    if (duration == null) return '0:00'; // Default if no duration
    final parts = duration.split(':');
    final minutes = parts.isNotEmpty ? int.tryParse(parts[0]) ?? 0 : 0;
    final seconds = parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0;
    return '$minutes:${seconds.toString().padLeft(2, '0')}'; // Format duration
  }
}
