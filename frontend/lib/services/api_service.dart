import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/music.dart';
import '../models/playlist.dart';
import 'dart:async'; // For TimeoutException

class ApiService {
  static const String lastFmApiKey = 'ced6c0e405a475a7684592655bccbc17'; // Last.fm API key
  static const String lastFmBaseUrl = 'https://ws.audioscrobbler.com/2.0/'; // Last.fm base URL
  static const String baseApiUrl = 'http://127.0.0.1:8000/api/'; // Base API URL for your backend

  /// Handle HTTP errors
  static void _handleHttpError(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed with status code: ${response.statusCode} - ${response.reasonPhrase}');
    }
  }

  /// Fetch popular music from Last.fm
  static Future<List<Music>> fetchMusic() async {
    final url = '$lastFmBaseUrl'
        '?method=chart.gettoptracks' // Endpoint for getting top tracks
        '&api_key=$lastFmApiKey'
        '&format=json';

    try {
      final response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 10)); // Timeout for slow connections
      _handleHttpError(response); // Handle errors

      final data = json.decode(response.body);
      List jsonResponse = data['tracks']['track']; // Parsing Last.fm response
      return jsonResponse.map((track) => Music.fromJson(track)).toList(); // Convert to Music model
    } catch (error) {
      // Improved error handling
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
    // Ensure a throw statement in case something goes wrong unexpectedly
    throw Exception('Unexpected error: Failed to fetch music.');
  }

  /// Fetch music by artist from Last.fm
  static Future<List<Music>> fetchMusicByArtist(String artist) async {
    final url = '$lastFmBaseUrl'
        '?method=artist.gettoptracks' // Endpoint to get top tracks by artist
        '&artist=$artist' // Query parameter for the artist
        '&api_key=$lastFmApiKey'
        '&format=json';

    try {
      final response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 10)); // Timeout for slow connections
      _handleHttpError(response); // Handle errors

      final data = json.decode(response.body);
      List jsonResponse = data['toptracks']['track']; // Parsing Last.fm response
      return jsonResponse.map((track) => Music.fromJson(track)).toList(); // Convert to Music model
    } catch (error) {
      // Improved error handling
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
    // Ensure a throw statement in case something goes wrong unexpectedly
    throw Exception('Unexpected error: Failed to fetch music by artist.');
  }

  /// Fetch playlists from the backend API
  static Future<List<Playlist>> fetchPlaylists() async {
    final url = '$baseApiUrl/playlists/'; // Adjust this endpoint as needed

    try {
      final response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 10)); // Timeout for slow connections
      _handleHttpError(response); // Handle errors

      final data = json.decode(response.body);
      List jsonResponse = data['playlists']; // Adjust according to your API response structure
      return jsonResponse.map((playlist) => Playlist.fromJson(playlist)).toList(); // Convert to Playlist model
    } catch (error) {
      // Improved error handling
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
    // Ensure a throw statement in case something goes wrong unexpectedly
    throw Exception('Unexpected error: Failed to fetch playlists.');
  }

  /// POST request for user registration
  static Future<void> registerUser(String username, String password) async {
    final url = '$baseApiUrl/register/'; // Update this to your registration endpoint if needed

    try {
      final response = await http
          .post(
            Uri.parse(url),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({'username': username, 'password': password}), // Send username and password
          )
          .timeout(const Duration(seconds: 10)); // Timeout for slow connections
      _handleHttpError(response); // Handle errors
    } catch (error) {
      // Improved error handling
      if (error is http.ClientException) {
        throw Exception('Network error: ${error.message}');
      } else if (error is TimeoutException) {
        throw Exception('Request timed out. Please try again later.');
      } else {
        throw Exception('Error registering user: ${error.toString()}');
      }
    }
    // No return needed since the method is void
  }

  /// POST request for user login
  static Future<void> loginUser(String username, String password) async {
    final url = '$baseApiUrl/login/'; // Update this to your login endpoint if needed

    try {
      final response = await http
          .post(
            Uri.parse(url),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({'username': username, 'password': password}), // Send username and password
          )
          .timeout(const Duration(seconds: 10)); // Timeout for slow connections
      _handleHttpError(response); // Handle errors
    } catch (error) {
      // Improved error handling
      if (error is http.ClientException) {
        throw Exception('Network error: ${error.message}');
      } else if (error is TimeoutException) {
        throw Exception('Request timed out. Please try again later.');
      } else {
        throw Exception('Error logging in user: ${error.toString()}');
      }
    }
    // No return needed since the method is void
  }

  /// Additional methods related to playlists can be added if needed
  /// Example: Creating, updating, or deleting playlists can be handled here
}
