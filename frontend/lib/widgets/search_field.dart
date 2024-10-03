import 'package:flutter/material.dart';

class SearchField extends StatefulWidget {
  final Function(String) onSearch; // Callback function to pass the search query back

  const SearchField({Key? key, required this.onSearch}) : super(key: key);

  @override
  _SearchFieldState createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  final TextEditingController searchController = TextEditingController();
  bool isLoading = false; // To track loading state

  void searchMusic() async {
    String query = searchController.text.trim(); // Get search query

    if (query.isNotEmpty) {
      setState(() {
        isLoading = true; // Start loading
      });

      // Simulate a search function (replace with your actual search API)
      await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
      print('Searching for: $query'); // Print the search query for debugging

      // Notify parent widget of the search query
      widget.onSearch(query);

      setState(() {
        isLoading = false; // Stop loading
      });
    }
  }

  void clearSearch() {
    searchController.clear(); // Clear the search field
    widget.onSearch(''); // Notify parent to clear search results
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: TextField(
        key: const Key('searchField'),
        controller: searchController,
        style: const TextStyle(color: Colors.black), // Text color changed to black for contrast
        decoration: InputDecoration(
          hintText: "Search for a song...",
          hintStyle: const TextStyle(color: Colors.black54), // Hint color changed to black54
          filled: true,
          fillColor: const Color(0xFFE3F2FD), // Light gray background for search field
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0), // Rounded corners
            borderSide: BorderSide.none,
          ),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isLoading)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.secondary, // Use colorScheme
                    strokeWidth: 2,
                  ),
                )
              else ...[
                IconButton(
                  icon: Icon(Icons.search, color: Theme.of(context).colorScheme.secondary), // Use colorScheme
                  onPressed: searchMusic,
                  key: const Key('searchButton'),
                ),
                IconButton(
                  icon: const Icon(Icons.clear, color: Colors.black), // Clear icon color changed to black
                  onPressed: clearSearch,
                  key: const Key('clearButton'),
                ),
              ],
            ],
          ),
        ),
        // Call searchMusic when user submits the form (via keyboard)
        onSubmitted: (value) {
          searchMusic();
        },
      ),
    );
  }
}
