import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart'; // Import the audioplayers package
import '../models/music.dart';

class MusicCard extends StatefulWidget {
  final Music music;
  final Function(Music) onPlay; // Accept onPlay function

  const MusicCard({Key? key, required this.music, required this.onPlay}) : super(key: key);

  @override
  _MusicCardState createState() => _MusicCardState();
}

class _MusicCardState extends State<MusicCard> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false; // To track if music is playing
  bool isLoading = false; // To track loading state

  @override
  void initState() {
    super.initState();
    // Listen for audio completion
    _audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        isPlaying = false; // Reset playing state when the audio completes
      });
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose(); // Dispose of the audio player when done
    super.dispose();
  }

  Future<void> _playMusic() async {
    setState(() {
      isLoading = true; // Start loading
    });

    try {
      if (widget.music.audioUrl != null) {
        await _audioPlayer.play(UrlSource(widget.music.audioUrl!)); // Use UrlSource
        setState(() {
          isPlaying = true; // Update playing state
        });
      } else {
        _showSnackBar('Audio URL is not available');
      }
    } catch (error) {
      _showSnackBar('Error playing music: $error');
    } finally {
      setState(() {
        isLoading = false; // Stop loading
      });
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.onPlay(widget.music), // Call the onPlay function on tap
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        decoration: BoxDecoration(
          color: const Color(0xFF1D1D1D), // Card background color
          borderRadius: BorderRadius.circular(15), // Rounded corners
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4), // Soft shadow
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(10.0), // Rounded album image
            child: Image.network(
              widget.music.albumCoverUrl ?? '', // Fallback to an empty string if null
              fit: BoxFit.cover,
              width: 60,
              height: 60,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 60,
                  height: 60,
                  color: Colors.grey, // Placeholder color for broken image
                  child: const Icon(Icons.music_note, color: Colors.white), // Fallback icon
                );
              },
            ),
          ),
          title: Text(
            widget.music.title,
            style: Theme.of(context).textTheme.titleLarge, // Updated to headline6 for better consistency
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.music.artist,
                style: Theme.of(context).textTheme.bodyLarge, // Updated to bodyText2 for better consistency
              ),
              Text(
                _formatDuration(widget.music.duration), // Format duration
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey), // Optional style
              ),
            ],
          ),
          trailing: isLoading
              ? const CircularProgressIndicator() // Show loading indicator
              : IconButton(
                  icon: Icon(
                    isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
                    color: Theme.of(context).colorScheme.secondary,
                    size: 40,
                  ),
                  onPressed: isPlaying ? _audioPlayer.pause : _playMusic,
                ),
        ),
      ),
    );
  }

  // Method to format duration
  String _formatDuration(String? duration) {
    if (duration == null || !duration.contains('.')) return '0:00'; // Basic validation
    final parts = duration.split('.');
    final minutes = int.parse(parts[0]);
    final seconds = (double.parse(parts[1]) * 60).round();
    return '$minutes:${seconds.toString().padLeft(2, '0')}'; // Format as "MM:SS"
  }
}