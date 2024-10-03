import 'package:flutter/material.dart';
import '../models/music.dart'; // Importing the Music model
import '../widgets/music_card.dart'; // Importing the MusicCard widget

class HomeScreen extends StatelessWidget {
  // A map that categorizes music, where each key is a category name and the value is a list of Music objects
  final Map<String, List<Music>> categorizedMusic;

  // A callback function that takes a Music object as an argument, triggered when a music item is played
  final Function(Music) onPlay; 

  // Constructor for HomeScreen that requires categorizedMusic and onPlay parameters
  const HomeScreen({
    Key? key,
    required this.categorizedMusic, // Required parameter for categorized music
    required this.onPlay, // Required callback function
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // AppBar configuration
        title: const Text("Home"), // Title of the app
        backgroundColor: const Color(0xFF4A90E2), // Background color for the AppBar
        actions: [
          IconButton(
            icon: const Icon(Icons.settings), // Settings icon in the AppBar
            onPressed: () {
              // Navigates to the settings screen when pressed
              Navigator.of(context).pushNamed('/settings');
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.grey[300], // Set the background color to light gray
        child: ListView(
          padding: const EdgeInsets.all(16.0), // Padding around the list view
          children: categorizedMusic.entries.map((entry) {
            final category = entry.key; // Fetching the category name
            final musicList = entry.value; // Fetching the list of music items for the category

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0), // Vertical spacing between categories
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // Aligns the category title to the start
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0), // Horizontal padding for category title
                    child: Text(
                      category, // Displays the name of the category
                      style: const TextStyle(
                        fontSize: 26, // Font size for category title
                        fontWeight: FontWeight.w800, // Font weight for emphasis
                        color: Color(0xFF4A90E2), // Color for the category title
                        letterSpacing: 1.2, // Spacing between letters for readability
                      ),
                    ),
                  ),
                  const SizedBox(height: 12.0), // Space between the title and music cards
                  SizedBox(
                    height: 160, // Fixed height for the horizontal list of music cards
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal, // Enables horizontal scrolling for music cards
                      itemCount: musicList.length, // Total number of music items in the category
                      itemBuilder: (context, index) {
                        final music = musicList[index]; // Fetches the current music item

                        return Padding(
                          padding: const EdgeInsets.only(right: 12.0), // Spacing between music cards
                          child: MusicCard(
                            music: music, // Passing the current music object to MusicCard
                            onPlay: onPlay, // Passing the onPlay function to handle play actions
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }).toList(), // Converts the map entries to a list of widgets
        ),
      ),
    );
  }
}
