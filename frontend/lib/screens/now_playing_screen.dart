import 'package:flutter/material.dart';
import '../models/music.dart'; // Ensure you have the Music model imported
import 'dart:async'; // Import for Timer

class NowPlayingScreen extends StatefulWidget {
  final Music music;

  const NowPlayingScreen({Key? key, required this.music}) : super(key: key);

  @override
  _NowPlayingScreenState createState() => _NowPlayingScreenState();
}

class _NowPlayingScreenState extends State<NowPlayingScreen> {
  bool isPlaying = false; // Track play/pause state
  double currentPosition = 0.0; // Current position of the song
  double totalDuration = 210.0; // Total duration of the song (in seconds)
  Timer? _timer; // Timer for updating current position

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (currentPosition < totalDuration) {
          currentPosition += 1; // Increment current position
        } else {
          _timer?.cancel(); // Stop timer if the song ends
        }
      });
    });
  }

  void _togglePlayPause() {
    setState(() {
      isPlaying = !isPlaying; // Toggle play/pause state
      if (isPlaying) {
        _startTimer(); // Start timer when playing
      } else {
        _timer?.cancel(); // Stop timer when paused
      }
    });
    // Logic to play/pause music
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Dark background
      appBar: AppBar(
        title: const Text("Now Playing"),
        backgroundColor: const Color(0xFF1D1D1D),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Album Art
          ClipRRect(
            borderRadius: BorderRadius.circular(15.0), // Rounded corners for album art
            child: Image.network(
              widget.music.albumCoverUrl ?? 'https://via.placeholder.com/250', // Placeholder URL
              fit: BoxFit.cover,
              height: 250,
              width: 250,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 250,
                  width: 250,
                  color: Colors.grey,
                  child: const Icon(Icons.error, color: Colors.red), // Error placeholder
                );
              },
            ),
          ),
          const SizedBox(height: 20),

          // Song Title
          Text(
            widget.music.title,
            style: Theme.of(context).textTheme.headlineMedium, // Updated headline style
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),

          // Artist Name
          Text(
            widget.music.artist,
            style: Theme.of(context).textTheme.bodyLarge, // Updated body text style
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),

          // Playback Controls
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.skip_previous, size: 40, color: Colors.white),
                onPressed: () {
                  // Logic to play the previous song
                },
              ),
              IconButton(
                icon: Icon(
                  isPlaying ? Icons.pause : Icons.play_arrow,
                  size: 60,
                  color: Colors.white,
                ),
                onPressed: _togglePlayPause,
              ),
              IconButton(
                icon: const Icon(Icons.skip_next, size: 40, color: Colors.white),
                onPressed: () {
                  // Logic to play the next song
                },
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Seek Bar
          Slider(
            value: currentPosition, // Update with current position
            onChanged: (value) {
              setState(() {
                currentPosition = value; // Update position locally
              });
              // Logic to seek music
            },
            min: 0,
            max: totalDuration, // Adjust max based on total duration
            activeColor: Theme.of(context).colorScheme.secondary, // Updated active color
            inactiveColor: Colors.white54,
          ),

          const SizedBox(height: 20),

          // Current Duration and Total Duration
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_formatDuration(currentPosition), style: const TextStyle(color: Colors.white)), // Current position
              Text(_formatDuration(totalDuration), style: const TextStyle(color: Colors.white)), // Total duration
            ],
          ),
        ],
      ),
    );
  }

  String _formatDuration(double seconds) {
    final minutes = (seconds / 60).floor();
    final secs = (seconds % 60).floor();
    return '${minutes.toString().padLeft(1, '0')}:${secs.toString().padLeft(2, '0')}';
  }
}
