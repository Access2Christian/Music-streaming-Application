import 'package:flutter/material.dart';
import '../models/music.dart';
import '../widgets/music_card.dart'; // Ensure this path is correct

class HomeScreen extends StatelessWidget {
  final Map<String, List<Music>> categorizedMusic; // Music categorized by genre or category
  final Function(Music) onPlay; // Function to handle play action

  const HomeScreen({Key? key, required this.categorizedMusic, required this.onPlay}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: categorizedMusic.entries.map((entry) {
        final category = entry.key; // The category name (e.g., Pop, Rock)
        final musicList = entry.value; // List of music items in this category

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  category,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              // Create a horizontal list view for music cards in this category
              SizedBox(
                height: 150, // Adjust height as needed
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: musicList.length,
                  itemBuilder: (context, index) {
                    final music = musicList[index];
                    return MusicCard(
                      music: music,
                      onPlay: onPlay, // Pass the onPlay function to MusicCard
                    );
                  },
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

