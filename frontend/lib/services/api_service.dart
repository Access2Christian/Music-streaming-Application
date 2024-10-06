import 'dart:convert'; // For converting JSON data
import 'package:http/http.dart' as http; // Import HTTP package for API requests
import '../models/music.dart'; // Import the Music model
import 'dart:async'; // For handling TimeoutException

class ApiService {
  static const String baseApiUrl = 'http://127.0.0.1:8000/api/'; // Base API URL for Django backend

  static void _handleHttpError(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed with status code: ${response.statusCode} - ${response.reasonPhrase}');
    }
  }

  /// Fetch music data from the Django backend.
  static Future<List<Music>> fetchShazamCharts() async {
    final url = Uri.parse('${baseApiUrl}music/');

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 15));
      _handleHttpError(response);

      final data = jsonDecode(response.body);
      return List<Music>.from(data.map((song) => Music.fromJson(song))); // Convert JSON to Music objects
    } catch (error) {
      throw _handleFetchError(error, 'music data');
    }
  }

    /// Fetch music data from the Django backend.
  static Future<List<Music>> fetchPlaylists() async {
    final url = Uri.parse('${baseApiUrl}music/');

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 15));
      _handleHttpError(response);

      final data = jsonDecode(response.body);
      return List<Music>.from(data.map((song) => Music.fromJson(song))); // Convert JSON to Music objects
    } catch (error) {
      throw _handleFetchError(error, 'music data');
    }
  }

  /// Registers a new user.
  static Future<void> registerUser(String username, String password) async {
    const url = '${baseApiUrl}register/';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'username': username, 'password': password}),
      ).timeout(const Duration(seconds: 10));

      _handleHttpError(response);
    } catch (error) {
      throw _handleFetchError(error, 'user registration');
    }
  }

  /// Logs in a user.
  static Future<void> loginUser(String username, String password) async {
    const url = '${baseApiUrl}login/';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'username': username, 'password': password}),
      ).timeout(const Duration(seconds: 10));

      _handleHttpError(response);
    } catch (error) {
      throw _handleFetchError(error, 'user login');
    }
  }

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
