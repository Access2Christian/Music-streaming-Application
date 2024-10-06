import 'package:flutter/material.dart';
import 'package:logger/logger.dart'; // Import the logger package

class SearchField extends StatefulWidget {
  // Callback function to pass the search query back to the parent widget
  final Function(String) onSearch;

  const SearchField({Key? key, required this.onSearch}) : super(key: key);

  @override
  SearchFieldState createState() => SearchFieldState();
}

class SearchFieldState extends State<SearchField> {
  final TextEditingController searchController = TextEditingController(); // Controller for the search text field
  bool isLoading = false; // To track the loading state while searching
  final Logger logger = Logger(); // Initialize logger instance for logging

  // Function to perform the search
  void searchMusic() async {
    String query = searchController.text.trim(); // Get and trim the search query

    if (query.isNotEmpty) {
      setState(() {
        isLoading = true; // Start loading state
      });

      // Simulate a search function (replace with your actual search API)
      await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
      logger.i('Searching for: $query'); // Log the search query for debugging

      // Notify the parent widget of the search query
      widget.onSearch(query);

      setState(() {
        isLoading = false; // Stop loading state
      });
    }
  }

  // Function to clear the search field and notify the parent
  void clearSearch() {
    searchController.clear(); // Clear the search text field
    widget.onSearch(''); // Notify the parent to clear search results
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0), // Add padding around the search field
      child: TextField(
        key: const Key('searchField'), // Key for testing purposes
        controller: searchController, // Controller for managing text input
        style: const TextStyle(color: Colors.black), // Set text color to black for visibility
        decoration: InputDecoration(
          hintText: "Search for a song...", // Placeholder text
          hintStyle: const TextStyle(color: Colors.black54), // Style for hint text
          filled: true,
          fillColor: const Color(0xFFE3F2FD), // Light background color for the search field
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0), // Rounded corners for the input field
            borderSide: BorderSide.none, // Remove border side for a clean look
          ),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min, // Minimize the row size
            children: [
              // Show a loading indicator while searching
              if (isLoading)
                Padding(
                  padding: const EdgeInsets.all(8.0), // Padding for the loading indicator
                  child: CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.secondary, // Use theme's secondary color
                    strokeWidth: 2, // Width of the loading indicator
                  ),
                )
              else ...[
                // Search icon button
                IconButton(
                  icon: Icon(Icons.search, color: Theme.of(context).colorScheme.secondary), // Use theme's secondary color
                  onPressed: searchMusic, // Trigger search on press
                  key: const Key('searchButton'), // Key for testing purposes
                ),
                // Clear icon button
                IconButton(
                  icon: const Icon(Icons.clear, color: Colors.black), // Clear icon color set to black
                  onPressed: clearSearch, // Trigger clear on press
                  key: const Key('clearButton'), // Key for testing purposes
                ),
              ],
            ],
          ),
        ),
        // Trigger searchMusic when the user submits the form (via keyboard)
        onSubmitted: (value) {
          searchMusic();
        },
      ),
    );
  }
}
