import 'dart:convert'; // For converting JSON data
import 'package:http/http.dart' as http; // Import HTTP package for API requests
import '../models/music.dart'; // Import the Music model
import '../models/playlist.dart'; // Import the Playlist model
import 'dart:async'; // To handle TimeoutException

class ApiService {
  // Define API keys and URLs
  static const String lastFmApiKey = 'ced6c0e405a475a7684592655bccbc17'; // Last.fm API key
  static const String lastFmBaseUrl = 'http://ws.audioscrobbler.com/2.0/'; // Base URL for Last.fm API
  static const String baseApiUrl = 'http://127.0.0.1:8000/api/'; // Base API URL for our Django backend

  /// Helper method to handle HTTP response errors
  /// Throws an exception if the response status code indicates a failure.
  static void _handleHttpError(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed with status code: ${response.statusCode} - ${response.reasonPhrase}');
    }
  }

  /// Fetch popular music from Last.fm
  /// This method makes a GET request to Last.fm and returns a list of popular music tracks.
  static Future<List<Music>> fetchMusic() async {
    const url = '$lastFmBaseUrl?method=chart.gettoptracks&api_key=$lastFmApiKey&format=json'; // Complete API URL

    try {
      // Make the API call and wait for response (with 10-second timeout)
      final response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));
      
      _handleHttpError(response); // Handle any HTTP errors

      // Parse the JSON response
      final data = json.decode(response.body);
      List jsonResponse = data['tracks']['track']; // Extract the 'track' list from JSON

      // Convert the JSON response to a list of Music objects
      return jsonResponse.map((track) => Music.fromJson(track)).toList();
    } catch (error) {
      // Error handling for different types of failures
      if (error is http.ClientException) {
        throw Exception('Network error: ${error.message}');
      } else if (error is TimeoutException) {
        throw Exception('Request timed out. Please try again later.');
      } else if (error is FormatException) {
        throw Exception('Invalid format received from API.');
      } else {
        throw Exception('Error fetching music from Last.fm: ${error.toString()}');
      }
    }
  }

  /// Fetch music by artist from Last.fm
  /// Given an artist's name, this method fetches their top tracks from Last.fm.
  static Future<List<Music>> fetchMusicByArtist(String artist) async {
    final url = '$lastFmBaseUrl?method=artist.gettoptracks&artist=$artist&api_key=$lastFmApiKey&format=json'; // Complete API URL

    try {
      // Make the API call and wait for response (with 10-second timeout)
      final response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));
      
      _handleHttpError(response); // Handle any HTTP errors

      // Parse the JSON response
      final data = json.decode(response.body);
      List jsonResponse = data['toptracks']['track']; // Extract the 'track' list for the artist

      // Convert the JSON response to a list of Music objects
      return jsonResponse.map((track) => Music.fromJson(track)).toList();
    } catch (error) {
      // Error handling for different types of failures
      if (error is http.ClientException) {
        throw Exception('Network error: ${error.message}');
      } else if (error is TimeoutException) {
        throw Exception('Request timed out. Please try again later.');
      } else if (error is FormatException) {
        throw Exception('Invalid format received from API.');
      } else {
        throw Exception('Error fetching music by artist from Last.fm: ${error.toString()}');
      }
    }
  }

  /// Fetch playlists from the Django backend API
  /// This method fetches a list of playlists created in the backend.
  static Future<List<Playlist>> fetchPlaylists() async {
    const url = '$baseApiUrl/playlists/'; // Adjust this endpoint according to your backend

    try {
      // Make the API call and wait for response (with 10-second timeout)
      final response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));
      
      _handleHttpError(response); // Handle any HTTP errors

      // Parse the JSON response
      final data = json.decode(response.body);
      List jsonResponse = data['playlists']; // Extract the 'playlists' list from JSON

      // Convert the JSON response to a list of Playlist objects
      return jsonResponse.map((playlist) => Playlist.fromJson(playlist)).toList();
    } catch (error) {
      // Error handling for different types of failures
      if (error is http.ClientException) {
        throw Exception('Network error: ${error.message}');
      } else if (error is TimeoutException) {
        throw Exception('Request timed out. Please try again later.');
      } else if (error is FormatException) {
        throw Exception('Invalid format received from API.');
      } else {
        throw Exception('Error fetching playlists: ${error.toString()}');
      }
    }
  }

  /// Search for music by title using Last.fm API
  /// Given a search query, this method fetches matching music tracks from Last.fm.
  static Future<List<Music>> searchMusic(String query) async {
    final url = '$lastFmBaseUrl?method=track.search&track=$query&api_key=$lastFmApiKey&format=json'; // Complete API URL

    try {
      // Make the API call and wait for response (with 10-second timeout)
      final response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));

      _handleHttpError(response); // Handle any HTTP errors

      // Parse the JSON response
      final data = json.decode(response.body);
      List jsonResponse = data['results']['trackmatches']['track']; // Extract the 'track' list from JSON

      // Convert the JSON response to a list of Music objects
      return jsonResponse.map((track) => Music.fromJson(track)).toList();
    } catch (error) {
      // Error handling for different types of failures
      if (error is http.ClientException) {
        throw Exception('Network error: ${error.message}');
      } else if (error is TimeoutException) {
        throw Exception('Request timed out. Please try again later.');
      } else if (error is FormatException) {
        throw Exception('Invalid format received from API.');
      } else {
        throw Exception('Error searching music from Last.fm: ${error.toString()}');
      }
    }
  }

  /// Register a new user via the backend API
  /// Sends a POST request to register a new user with the provided username and password.
  static Future<void> registerUser(String username, String password) async {
    const url = '$baseApiUrl/register/'; // Registration endpoint

    try {
      // Send a POST request with the user credentials
      final response = await http
          .post(
            Uri.parse(url),
            headers: {'Content-Type': 'application/json'}, // Set the request headers
            body: json.encode({'username': username, 'password': password}), // Pass the username and password
          )
          .timeout(const Duration(seconds: 10)); // Set a timeout
      
      _handleHttpError(response); // Handle any HTTP errors
    } catch (error) {
      // Error handling for registration failures
      if (error is http.ClientException) {
        throw Exception('Network error: ${error.message}');
      } else if (error is TimeoutException) {
        throw Exception('Request timed out. Please try again later.');
      } else {
        throw Exception('Error registering user: ${error.toString()}');
      }
    }
  }

  /// Log in an existing user via the backend API
  /// Sends a POST request to log in the user with the provided credentials.
  static Future<void> loginUser(String username, String password) async {
    const url = '$baseApiUrl/login/'; // Login endpoint

    try {
      // Send a POST request with the user credentials
      final response = await http
          .post(
            Uri.parse(url),
            headers: {'Content-Type': 'application/json'}, // Set the request headers
            body: json.encode({'username': username, 'password': password}), // Pass the username and password
          )
          .timeout(const Duration(seconds: 10)); // Set a timeout

      _handleHttpError(response); // Handle any HTTP errors
    } catch (error) {
      // Error handling for login failures
      if (error is http.ClientException) {
        throw Exception('Network error: ${error.message}');
      } else if (error is TimeoutException) {
        throw Exception('Request timed out. Please try again later.');
      } else {
        throw Exception('Error logging in user: ${error.toString()}');
      }
    }
  }
}
