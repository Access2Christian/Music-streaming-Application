import 'package:flutter/material.dart';
import '../models/music.dart';
import 'dart:async';

class NowPlayingScreen extends StatefulWidget {
  final Music music; // The music being played

  const NowPlayingScreen({Key? key, required this.music}) : super(key: key);

  @override
  _NowPlayingScreenState createState() => _NowPlayingScreenState();
}

class _NowPlayingScreenState extends State<NowPlayingScreen> {
  bool isPlaying = false; // Tracks whether the music is playing or paused
  double currentPosition = 0.0; // Current position of the song
  double totalDuration = 210.0; // Example total duration of the song
  Timer? _timer; // Timer for song progress

  @override
  void dispose() {
    _timer?.cancel(); // Cancels timer when screen is closed
    super.dispose();
  }

  // Starts the timer to simulate music playback
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (currentPosition < totalDuration) {
          currentPosition += 1; // Increases the position each second
        } else {
          _timer?.cancel(); // Stops the timer when the song ends
        }
      });
    });
  }

  // Toggles between play and pause
  void _togglePlayPause() {
    setState(() {
      isPlaying = !isPlaying;
      isPlaying ? _startTimer() : _timer?.cancel(); // Pauses or resumes the timer
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECEFF1), // Light gray background
      appBar: AppBar(
        title: const Text("Now Playing"),
        backgroundColor: const Color(0xFF4A90E2), // Soft blue AppBar
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildAlbumCover(),
          const SizedBox(height: 20), // Spacing between album and song details
          _buildSongTitle(),
          const SizedBox(height: 10),
          _buildArtistName(),
          const SizedBox(height: 20),
          _buildPlaybackControls(),
          const SizedBox(height: 20),
          _buildSeekBar(),
          const SizedBox(height: 20),
          _buildDurationRow(),
        ],
      ),
    );
  }

  // Displays the album cover of the song
  Widget _buildAlbumCover() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15.0), // Rounded corners for the image
      child: Image.network(
        widget.music.albumCoverUrl ?? 'https://via.placeholder.com/250', // Placeholder if no album cover
        fit: BoxFit.cover,
        height: 250,
        width: 250,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: 250,
            width: 250,
            color: Colors.grey, // Fallback color if image fails
            child: const Icon(Icons.error, color: Colors.red), // Error icon
          );
        },
      ),
    );
  }

  // Displays the song title
  Widget _buildSongTitle() {
    return Text(
      widget.music.title,
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Color(0xFF4A90E2), // Soft blue for song title
      ),
      textAlign: TextAlign.center,
    );
  }

  // Displays the artist name
  Widget _buildArtistName() {
    return Text(
      widget.music.artist,
      style: const TextStyle(
        fontSize: 18,
        color: Color(0xFF5A4D3A), // Slightly darker tone for artist name
      ),
      textAlign: TextAlign.center,
    );
  }

  // Controls for play, pause, previous, and next
  Widget _buildPlaybackControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.skip_previous, size: 40, color: Color(0xFF5A4D3A)),
          onPressed: () {
            // Logic to play the previous song
          },
        ),
        IconButton(
          icon: Icon(
            isPlaying ? Icons.pause : Icons.play_arrow,
            size: 60,
            color: const Color(0xFF4A90E2), // Soft blue for play/pause button
          ),
          onPressed: _togglePlayPause, // Toggles play/pause functionality
        ),
        IconButton(
          icon: const Icon(Icons.skip_next, size: 40, color: Color(0xFF5A4D3A)),
          onPressed: () {
            // Logic to play the next song
          },
        ),
      ],
    );
  }

  // Seek bar for tracking song progress
  Widget _buildSeekBar() {
    return Slider(
      value: currentPosition, // Current position of the song
      onChanged: (value) {
        setState(() {
          currentPosition = value; // Updates the current position
        });
      },
      min: 0,
      max: totalDuration, // Total duration of the song
      activeColor: const Color(0xFF4A90E2), // Soft blue for active part of the slider
      inactiveColor: const Color(0xFFC8B591), // Light beige for inactive part
    );
  }

  // Displays the current position and total duration of the song
  Widget _buildDurationRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            _formatDuration(currentPosition), // Formats the current position
            style: const TextStyle(color: Color(0xFF5A4D3A)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            _formatDuration(totalDuration), // Formats the total duration
            style: const TextStyle(color: Color(0xFF5A4D3A)),
          ),
        ),
      ],
    );
  }

  // Helper function to format duration into minutes and seconds
  String _formatDuration(double seconds) {
    final minutes = (seconds / 60).floor();
    final secs = (seconds % 60).floor();
    return '${minutes.toString().padLeft(1, '0')}:${secs.toString().padLeft(2, '0')}'; // MM:SS format
  }
}
