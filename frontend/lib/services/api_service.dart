import 'dart:convert'; // For converting JSON data
import 'package:http/http.dart' as http; // Import HTTP package for API requests
import 'package:shared_preferences/shared_preferences.dart'; // To store token locally
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
      final token = await _getToken(); // Retrieve the stored token
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Token $token', // Use 'Token' instead of 'Bearer'
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 15));

      _handleHttpError(response);

      final data = jsonDecode(response.body);
      return List<Music>.from(data.map((song) => Music.fromJson(song))); // Convert JSON to Music objects
    } catch (error) {
      throw _handleFetchError(error, 'music data');
    }
  }

  static Future<List<Music>> fetchPlaylists() async {
    final url = Uri.parse('${baseApiUrl}music/');

    try {
      final token = await _getToken(); // Retrieve the stored token
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Token $token', // Use 'Token' instead of 'Bearer'
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 15));

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

  /// Logs in a user and stores the token locally.
  static Future<void> loginUser(String username, String password) async {
    const url = '${baseApiUrl}login/';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'username': username, 'password': password}),
      ).timeout(const Duration(seconds: 10));

      _handleHttpError(response);

      // Assuming the token is returned in the response body as `token`
      final responseData = jsonDecode(response.body);
      if (responseData.containsKey('token')) { // Check if token exists
        final token = responseData['token']; // Adjust based on actual key
        await _storeToken(token); // Store the token locally
      } else {
        throw Exception('Login failed: Token not found in response');
      }
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

  /// Store the authentication token locally using SharedPreferences
  static Future<void> _storeToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('authToken', token);
  }

  /// Retrieve the authentication token from SharedPreferences
  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('authToken');
  }
}
