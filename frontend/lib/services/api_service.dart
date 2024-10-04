import 'dart:convert'; // For converting JSON data
import 'package:http/http.dart' as http; // Import HTTP package for API requests
import '../models/music.dart'; // Import the Music model
import '../models/playlist.dart'; // Import the Playlist model
import 'dart:async'; // To handle TimeoutException

class ApiService {
  // API base constants and keys
  static const String shazamApiKey = '2eb727c693msh7f22be1c5aefefdp180abfjsn6a16de4195a2'; // Shazam API key
  static const String shazamBaseUrl = 'https://shazam.p.rapidapi.com'; // Base URL for Shazam API
  static const String baseApiUrl = 'http://127.0.0.1:8000/api/'; // Base API URL for our Django backend

  /// Helper method to handle HTTP response errors
  /// If the status code is not 2xx, throws an exception with the appropriate message.
  static void _handleHttpError(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed with status code: ${response.statusCode} - ${response.reasonPhrase}');
    }
  }

  /// Fetch the latest release of an artist from Shazam
  /// 
  /// Takes an artist's ID and makes a GET request to the Shazam API to fetch the top songs.
  /// Returns a list of song IDs. Throws an exception if the request fails or times out.
  static Future<List<String>> fetchTopSongs(String artistId) async {
    final url = Uri.parse('$shazamBaseUrl/artists/get-top-songs?id=$artistId&l=en-US'); // Complete API URL

    try {
      // Make the GET request with headers and timeout
      final response = await http.get(
        url, // Use the parsed URL
        headers: {
          'x-rapidapi-host': 'shazam.p.rapidapi.com',
          'x-rapidapi-key': shazamApiKey,
        },
      ).timeout(const Duration(seconds: 15));

      // Check if the response is successful (status code 200)
      if (response.statusCode == 200) {
        // Decode JSON response
        final data = jsonDecode(response.body);
        List<String> songIds = [];

        // Assuming 'tracks' is the key that contains the list of songs
        for (var song in data['tracks']) {
          songIds.add(song['key']); // Collect song ID (key)
        }

        return songIds; // Return the list of song IDs
      } else {
        throw Exception('Failed to load top songs'); // Handle unsuccessful status
      }
    } on TimeoutException catch (_) {
      // Handle timeout exceptions
      throw Exception('The request timed out');
    } catch (e) {
      // Handle any other type of exception
      throw Exception('An error occurred: $e');
    }
  }

  /// Fetch details of a specific Shazam song using its ID
  /// 
  /// Returns a `Music` object mapped from the API response.
  static Future<Music> fetchSongDetails(String songId) async {
    final url = '$shazamBaseUrl/shazam-songs/get-details?id=$songId&locale=en-US'; // API URL for song details

    try {
      // Make the GET request with headers and timeout
      final response = await http.get(Uri.parse(url), headers: {
        'x-rapidapi-host': 'shazam.p.rapidapi.com',
        'x-rapidapi-key': shazamApiKey,
      }).timeout(const Duration(seconds: 15));

      _handleHttpError(response); // Check if the response contains an error

      final data = json.decode(response.body); // Parse the response body
      if (data['error'] != null) {
        throw Exception('Error fetching song details: ${data['error']}');
      }

      // Convert the parsed JSON to a `Music` object and return
      return Music.fromJson(data); 
    } catch (error) {
      // Handle specific types of errors
      if (error is http.ClientException) {
        throw Exception('Network error: ${error.message}');
      } else if (error is TimeoutException) {
        throw Exception('Request timed out. Please try again later.');
      } else if (error is FormatException) {
        throw Exception('Invalid format received from API.');
      } else {
        throw Exception('Error fetching song details: ${error.toString()}');
      }
    }
  }

  /// Fetch Shazam charts (e.g., top songs globally)
  /// 
  /// Returns a list of `Music` objects representing the top charts.
  static Future<List<Music>> fetchShazamCharts() async {
    final url = '$shazamBaseUrl/charts/list'; // API URL for Shazam charts

    try {
      // Make the GET request with headers and timeout
      final response = await http.get(Uri.parse(url), headers: {
        'x-rapidapi-host': 'shazam.p.rapidapi.com',
        'x-rapidapi-key': shazamApiKey,
      }).timeout(const Duration(seconds: 15));

      _handleHttpError(response); // Check for HTTP errors

      final data = json.decode(response.body); // Parse response body

      // Check for errors in the response
      if (data['error'] != null) {
        throw Exception('Error fetching charts: ${data['error']}');
      }

      List jsonResponse = data['charts']; // Adjust this key based on API response structure

      // Map JSON to `Music` objects and return a list
      return jsonResponse.map((chart) => Music.fromJson(chart)).toList();
    } catch (error) {
      if (error is http.ClientException) {
        throw Exception('Network error: ${error.message}');
      } else if (error is TimeoutException) {
        throw Exception('Request timed out. Please try again later.');
      } else if (error is FormatException) {
        throw Exception('Invalid format received from API.');
      } else {
        throw Exception('Error fetching charts: ${error.toString()}');
      }
    }
  }

  /// Register a new user by sending a POST request to the backend API
  /// 
  /// Takes the username and password, sends them to the API, and throws an exception if registration fails.
  static Future<void> registerUser(String username, String password) async {
    const url = '$baseApiUrl/register/'; // Backend registration endpoint

    try {
      // Send POST request with user details
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'}, // Ensure correct content-type
        body: json.encode({'username': username, 'password': password}),
      ).timeout(const Duration(seconds: 10));

      _handleHttpError(response); // Handle HTTP errors
    } catch (error) {
      // Handle various errors during registration
      if (error is http.ClientException) {
        throw Exception('Network error: ${error.message}');
      } else if (error is TimeoutException) {
        throw Exception('Request timed out. Please try again later.');
      } else {
        throw Exception('Error registering user: ${error.toString()}');
      }
    }
  }

  /// Log in a user by sending their credentials to the backend API
  /// 
  /// Sends a POST request with the user's username and password, throws an exception on failure.
  static Future<void> loginUser(String username, String password) async {
    const url = '$baseApiUrl/login/'; // Backend login endpoint

    try {
      // Send POST request with login details
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'}, // Ensure correct content-type
        body: json.encode({'username': username, 'password': password}),
      ).timeout(const Duration(seconds: 10));

      _handleHttpError(response); // Handle HTTP errors
    } catch (error) {
      if (error is http.ClientException) {
        throw Exception('Network error: ${error.message}');
      } else if (error is TimeoutException) {
        throw Exception('Request timed out. Please try again later.');
      } else {
        throw Exception('Error logging in user: ${error.toString()}');
      }
    }
  }

  /// Fetch the user's details from the backend API
  /// 
  /// Takes the user's ID and returns their information. Throws an exception if retrieval fails.
  static Future<void> fetchUserDetails(String userId) async {
    final url = '$baseApiUrl/user/$userId/'; // User details endpoint

    try {
      final response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 15));
      
      _handleHttpError(response); // Handle any HTTP errors

      // Process the user details...
    } catch (error) {
      if (error is http.ClientException) {
        throw Exception('Network error: ${error.message}');
      } else if (error is TimeoutException) {
        throw Exception('Request timed out. Please try again later.');
      } else {
        throw Exception('Error fetching user details: ${error.toString()}');
      }
    }
  }

  /// Fetch all playlists for a user from the backend API
  /// 
  /// Returns a list of `Playlist` objects representing the user's playlists.
  static Future<List<Playlist>> fetchPlaylists() async {
    const url = '$baseApiUrl/playlists/'; // Playlists endpoint

    try {
      final response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));

      _handleHttpError(response); // Handle HTTP errors

      final data = json.decode(response.body);
      return (data as List).map((json) => Playlist.fromJson(json)).toList(); // Convert JSON to list of Playlists
    } catch (error) {
      if (error is http.ClientException) {
        throw Exception('Network error: ${error.message}');
      } else if (error is TimeoutException) {
        throw Exception('Request timed out. Please try again later.');
      } else {
        throw Exception('Error fetching playlists: ${error.toString()}');
      }
    }
  }
}
