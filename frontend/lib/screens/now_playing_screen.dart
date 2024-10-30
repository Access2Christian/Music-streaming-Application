import 'package:flutter/material.dart';
import '../models/music.dart';
import 'dart:async';

class NowPlayingScreen extends StatefulWidget {
  final Music music; // Music being played, passed from parent widget

  const NowPlayingScreen({Key? key, required this.music}) : super(key: key);

  @override
  NowPlayingScreenState createState() => NowPlayingScreenState();
}

class NowPlayingScreenState extends State<NowPlayingScreen> {
  bool isPlaying = false; // Tracks whether music is playing or paused
  double currentPosition = 0.0; // Tracks current position of the song
  final double totalDuration = 210.0; // Example total duration of the song (in seconds)
  Timer? _timer; // Timer for simulating song progress

  @override
  void dispose() {
    _timer?.cancel(); // Cancel timer when screen is closed to prevent memory leaks
    super.dispose();
  }

  // Simulates music playback progress with a 1-second interval timer
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (currentPosition < totalDuration) {
          currentPosition += 1; // Increment song progress by 1 second
        } else {
          _timer?.cancel(); // Stop timer when song finishes
        }
      });
    });
  }

  // Toggles between play and pause states
  void _togglePlayPause() {
    setState(() {
      isPlaying = !isPlaying; // Toggle play/pause
      isPlaying ? _startTimer() : _timer?.cancel(); // Start or stop timer
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECEFF1), // Light gray background for subtle design
      appBar: AppBar(
        title: const Text("Now Playing"),
        backgroundColor: const Color(0xFF4A90E2), // Soft blue AppBar
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Center all content
        children: [
          _buildAlbumCover(), // Display album cover
          const SizedBox(height: 20), // Spacer between elements
          _buildSongTitle(), // Display song title
          const SizedBox(height: 10),
          _buildArtistName(), // Display artist name
          const SizedBox(height: 20),
          _buildPlaybackControls(), // Play, pause, next, and previous buttons
          const SizedBox(height: 20),
          _buildSeekBar(), // Seek bar for song progress
          const SizedBox(height: 20),
          _buildDurationRow(), // Display current position and total duration
        ],
      ),
    );
  }

  // Widget to display the album cover with rounded corners
  Widget _buildAlbumCover() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15.0), // Rounded corners
      child: Image.network(
        widget.music.albumCoverUrl?.replaceAll('http://', 'https://') ?? // Use secure URL format
            'https://images.pexels.com/photos/860707/pexels-photo-860707.jpeg', // Pexels image URL (placeholder)
        fit: BoxFit.cover,
        height: 250,
        width: 250,
        errorBuilder: (context, error, stackTrace) => _buildErrorAlbumCover(), // Fallback for load failure
      ),
    );
  }

  // Fallback widget for album cover loading error
  Widget _buildErrorAlbumCover() {
    return Container(
      height: 250,
      width: 250,
      color: Colors.grey, // Gray background
      child: const Icon(Icons.error, color: Colors.red), // Red error icon
    );
  }

  // Widget to display song title with styling
  Widget _buildSongTitle() {
    return Text(
      widget.music.title, // Accessing song title from Music model
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Color(0xFF4A90E2), // Soft blue text color
      ),
      textAlign: TextAlign.center,
    );
  }

  // Widget to display artist name with styling
  Widget _buildArtistName() {
    return Text(
      widget.music.artist, // Accessing artist name from Music model
      style: const TextStyle(
        fontSize: 18,
        color: Color(0xFF5A4D3A), // Darker color for artist name
      ),
      textAlign: TextAlign.center,
    );
  }

  // Widget for playback controls: previous, play/pause, next
  Widget _buildPlaybackControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.skip_previous, size: 40, color: Color(0xFF5A4D3A)),
          onPressed: () {
            // Logic for previous song action
          },
        ),
        IconButton(
          icon: Icon(
            isPlaying ? Icons.pause : Icons.play_arrow, // Toggle between pause/play
            size: 60,
            color: const Color(0xFF4A90E2), // Soft blue play/pause button
          ),
          onPressed: _togglePlayPause, // Toggle play/pause state
        ),
        IconButton(
          icon: const Icon(Icons.skip_next, size: 40, color: Color(0xFF5A4D3A)),
          onPressed: () {
            // Logic for next song action
          },
        ),
      ],
    );
  }

  // Widget for seek bar (progress bar) to display song progress
  Widget _buildSeekBar() {
    return Slider(
      value: currentPosition, // Current position of song
      onChanged: (value) {
        setState(() {
          currentPosition = value; // Update song position manually
        });
      },
      min: 0,
      max: totalDuration, // Total duration of the song
      activeColor: const Color(0xFF4A90E2), // Soft blue for active part of slider
      inactiveColor: const Color(0xFFC8B591), // Light beige for inactive part
    );
  }

  // Widget to display current position and total duration of the song
  Widget _buildDurationRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space between time stamps
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            _formatDuration(currentPosition), // Format current position (MM:SS)
            style: const TextStyle(color: Color(0xFF5A4D3A)), // Style for text
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            _formatDuration(totalDuration), // Format total duration (MM:SS)
            style: const TextStyle(color: Color(0xFF5A4D3A)),
          ),
        ),
      ],
    );
  }

  // Helper function to format duration (in seconds) into MM:SS format
  String _formatDuration(double seconds) {
    final minutes = (seconds / 60).floor(); // Extract minutes
    final secs = (seconds % 60).floor(); // Extract seconds
    return '${minutes.toString().padLeft(1, '0')}:${secs.toString().padLeft(2, '0')}'; // Return formatted string
  }
}
