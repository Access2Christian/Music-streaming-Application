import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/register_screen.dart';
import 'screens/login_screen.dart';
import 'screens/now_playing_screen.dart';
import 'screens/playlist_screen.dart';
import 'models/music.dart'; // Import your Music model
import 'services/api_service.dart'; // Import your API service

// Main function to run the app
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music Streaming App',
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 232, 234, 235),
        colorScheme: const ColorScheme.dark(
          primary: Color.fromARGB(103, 247, 243, 243),
          secondary: Color.fromARGB(255, 150, 158, 238),
        ),
        scaffoldBackgroundColor: const Color(0xFF121212),
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
          bodyMedium: TextStyle(fontSize: 16, color: Colors.white70),
          bodySmall: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      home: const MainScreen(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/playlist': (context) => const PlaylistScreen(),
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0; // Track the current index for the bottom navigation
  late Future<List<Music>> _musicList; // Future for fetching music

  @override
  void initState() {
    super.initState();
    _musicList = ApiService.fetchMusic(); // Fetch music from API
  }

  void _onDrawerItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onPlay(Music music) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => NowPlayingScreen(music: music), // Ensure NowPlayingScreen accepts Music
      ),
    );
  }

  void _showSearchDialog(BuildContext context) {
    TextEditingController searchController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Search Music'),
          content: TextField(
            controller: searchController,
            decoration: const InputDecoration(hintText: 'Enter artist name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _searchMusic(searchController.text); // Call search function
              },
              child: const Text('Search'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _searchMusic(String artist) {
    setState(() {
      _musicList = ApiService.fetchMusicByArtist(artist); // Update to fetch music by artist
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Music Streaming App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _showSearchDialog(context), // Call search dialog
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.of(context).pushNamed('/login');
            },
          ),
        ],
      ),
      drawer: CustomDrawer(onItemTap: _onDrawerItemTapped),
      body: _currentIndex == 0
          ? FutureBuilder<List<Music>>(
              future: _musicList,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No music available.'));
                } else {
                  // Assuming you need to categorize the music list
                  Map<String, List<Music>> categorizedMusic = {
                    'All Music': snapshot.data!, // or categorize as needed
                  };
                  return HomeScreen(
                    categorizedMusic: categorizedMusic, // Pass the categorized music
                    onPlay: _onPlay, // Pass the onPlay function
                  );
                }
              },
            )
          : _currentIndex == 1
              ? const Center(child: Text('Select a song to play')) // Placeholder for NowPlaying
              : const PlaylistScreen(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.play_arrow),
            label: 'Now Playing',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Playlist',
          ),
        ],
        selectedItemColor: const Color.fromARGB(255, 141, 139, 241),
      ),
    );
  }
}

class CustomDrawer extends StatelessWidget {
  final Function(int) onItemTap;

  const CustomDrawer({Key? key, required this.onItemTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(20)),
      ),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 163, 159, 226),
            ),
            child: Text(
              'Music Streaming',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          DrawerListTile(
            title: 'Home',
            onTap: () => _navigateToScreen(context, 0),
          ),
          DrawerListTile(
            title: 'Now Playing',
            onTap: () => _navigateToScreen(context, 1),
          ),
          DrawerListTile(
            title: 'Playlist',
            onTap: () => _navigateToScreen(context, 2),
          ),
          ListTile(
            title: const Text('Register'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed('/register');
            },
          ),
        ],
      ),
    );
  }

  void _navigateToScreen(BuildContext context, int screenIndex) {
    Navigator.of(context).pop(); // Close the drawer
    onItemTap(screenIndex); // Use the callback to update the index
  }
}

class DrawerListTile extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const DrawerListTile({
    required this.title,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      onTap: onTap,
      textColor: Colors.white, // Set text color to white
      tileColor: const Color.fromARGB(255, 39, 38, 38), // Set tile color to match the theme
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
    );
  }
}
