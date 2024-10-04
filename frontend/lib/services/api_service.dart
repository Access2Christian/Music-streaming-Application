import 'dart:convert'; // For converting JSON data
import 'package:http/http.dart' as http; // Import HTTP package for API requests
import '../models/music.dart'; // Import the Music model
import '../models/playlist.dart'; // Import the Playlist model
import 'dart:async'; // For handling TimeoutException

class ApiService {
  // API base constants and keys
  static const String shazamApiKey = '2eb727c693msh7f22be1c5aefefdp180abfjsn6a16de4195a2'; // Shazam API key
  static const String shazamBaseUrl = 'https://shazam.p.rapidapi.com'; // Base URL for Shazam API
  static const String baseApiUrl = 'http://127.0.0.1:8000/api/'; // Base API URL for our Django backend

  /// Handles HTTP response errors
  ///
  /// Throws an exception if the status code is not in the range of 200-299.
  static void _handleHttpError(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed with status code: ${response.statusCode} - ${response.reasonPhrase}');
    }
  }

  /// Fetches the latest release of an artist from Shazam.
  ///
  /// Takes an artist's ID and makes a GET request to the Shazam API to fetch the top songs.
  /// Returns a list of song IDs. Throws an exception if the request fails or times out.
  static Future<List<String>> fetchTopSongs(String artistId) async {
    final url = Uri.parse('$shazamBaseUrl/artists/get-top-songs?id=$artistId&l=en-US');

    try {
      final response = await http.get(
        url,
        headers: {
          'x-rapidapi-host': 'shazam.p.rapidapi.com',
          'x-rapidapi-key': shazamApiKey,
        },
      ).timeout(const Duration(seconds: 15));

      _handleHttpError(response); // Check if the response contains an error

      // Decode JSON response and collect song IDs
      final data = jsonDecode(response.body);
      return List<String>.from(data['tracks'].map((song) => song['key'])); // Collect song IDs
    } on TimeoutException catch (_) {
      throw Exception('The request timed out');
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }

  /// Fetches details of a specific Shazam song using its ID.
  ///
  /// Returns a `Music` object mapped from the API response.
  static Future<Music> fetchSongDetails(String songId) async {
    final url = '$shazamBaseUrl/shazam-songs/get-details?id=$songId&locale=en-US';

    try {
      final response = await http.get(Uri.parse(url), headers: {
        'x-rapidapi-host': 'shazam.p.rapidapi.com',
        'x-rapidapi-key': shazamApiKey,
      }).timeout(const Duration(seconds: 15));

      _handleHttpError(response); // Check if the response contains an error

      final data = json.decode(response.body);
      if (data['error'] != null) {
        throw Exception('Error fetching song details: ${data['error']}');
      }

      return Music.fromJson(data); // Convert the parsed JSON to a `Music` object
    } catch (error) {
      throw _handleFetchError(error, 'song details'); // Handle specific types of errors
    }
  }

  /// Fetches Shazam charts (e.g., top songs globally).
  ///
  /// Returns a list of `Music` objects representing the top charts.
  static Future<List<Music>> fetchShazamCharts() async {
    final url = '$shazamBaseUrl/charts/list';

    try {
      final response = await http.get(Uri.parse(url), headers: {
        'x-rapidapi-host': 'shazam.p.rapidapi.com',
        'x-rapidapi-key': shazamApiKey,
      }).timeout(const Duration(seconds: 15));

      _handleHttpError(response); // Check for HTTP errors

      final data = json.decode(response.body);
      if (data['error'] != null) {
        throw Exception('Error fetching charts: ${data['error']}');
      }

      return List<Music>.from(data['charts'].map((chart) => Music.fromJson(chart))); // Convert JSON to a list of Music objects
    } catch (error) {
      throw _handleFetchError(error, 'charts'); // Handle specific types of errors
    }
  }

  /// Registers a new user by sending a POST request to the backend API.
  ///
  /// Takes the username and password, sends them to the API, and throws an exception if registration fails.
  static Future<void> registerUser(String username, String password) async {
    const url = '$baseApiUrl/register/';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'username': username, 'password': password}),
      ).timeout(const Duration(seconds: 10));

      _handleHttpError(response); // Handle HTTP errors
    } catch (error) {
      throw _handleFetchError(error, 'user registration'); // Handle various errors during registration
    }
  }

  /// Logs in a user by sending their credentials to the backend API.
  ///
  /// Sends a POST request with the user's username and password, throws an exception on failure.
  static Future<void> loginUser(String username, String password) async {
    const url = '$baseApiUrl/login/';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'username': username, 'password': password}),
      ).timeout(const Duration(seconds: 10));

      _handleHttpError(response); // Handle HTTP errors
    } catch (error) {
      throw _handleFetchError(error, 'user login'); // Handle various errors during login
    }
  }

  /// Fetches the user's details from the backend API.
  ///
  /// Takes the user's ID and returns their information. Throws an exception if retrieval fails.
  static Future<void> fetchUserDetails(String userId) async {
    final url = '$baseApiUrl/user/$userId/';

    try {
      final response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 15));
      
      _handleHttpError(response); // Handle any HTTP errors
      // Additional processing of user details can be done here...
    } catch (error) {
      throw _handleFetchError(error, 'user details'); // Handle various errors during fetching user details
    }
  }

  /// Handles fetching playlists from the backend API.
  ///
  /// Currently, the backend does not manage playlists, so this method can be used for future implementation.
  static Future<List<Playlist>> fetchPlaylists() async {
    throw Exception('The backend currently does not manage playlists.'); // Indicate that the endpoint is not supported
  }

  /// Handles various fetch errors and returns a standardized error message.
  ///
  /// Takes the error and context as parameters to provide more information.
  static Exception _handleFetchError(dynamic error, String context) {
    if (error is http.ClientException) {
      return Exception('Network error while fetching $context: ${error.message}');
    } else if (error is TimeoutException) {
      return Exception('Request timed out while fetching $context. Please try again later.');
    } else {
      return Exception('Error fetching $context: ${error.toString()}');
    }
  }
}
