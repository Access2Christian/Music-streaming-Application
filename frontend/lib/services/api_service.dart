import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/music.dart';

/// A service class for API interactions with the backend and Pexels.
class ApiService {
  // Base URL for Django backend API
  static const String _baseApiUrl = 'http://127.0.0.1:8000/api/';

  // Pexels API URL and API Key for image search
  static const String _pexelsApiUrl = 'https://api.pexels.com/v1/search';
  static final String _pexelsApiKey = dotenv.env['PEXELS_API_KEY']!;

  /// Handles HTTP response errors by checking status codes
  /// and throwing an exception if an error status code is returned.
  static void _handleHttpError(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
          'Request failed with status code: ${response.statusCode} - ${response.reasonPhrase}');
    }
  }

  /// Fetches music data from the Django backend that retrieves Freesound data.
  static Future<List<Music>> fetchFreesoundMusic() async {
    // URL to the Django endpoint that provides Freesound data
    final url = Uri.parse('${_baseApiUrl}music/');
    try {
      // Retrieve the stored authentication token from SharedPreferences
      final token = await _getToken();
      
      // Send a GET request to the Django API with the authorization token in headers
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Token $token',  // Django token format
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 15));

      // Check for HTTP errors in the response
      _handleHttpError(response);

      // Decode JSON data and map it to a list of Music objects
      final data = jsonDecode(response.body);
      return List<Music>.from(data.map((sound) => Music.fromJson(sound)));
    } catch (error) {
      // If there's an error, create a standardized exception
      throw _createFetchException(error, 'Freesound music data');
    }
  }

  /// Fetches images from the Pexels API based on a search query.
  static Future<List<String>> fetchPexelsImages(String query) async {
    // URL for Pexels API, with a query parameter and a limit of 10 results
    final url = Uri.parse('$_pexelsApiUrl?query=$query&per_page=10');
    try {
      // Send a GET request to the Pexels API with the API key in headers
      final response = await http.get(
        url,
        headers: {
          'Authorization': _pexelsApiKey,
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 15));

      // Check for HTTP errors in the response
      _handleHttpError(response);

      // Decode JSON data and extract the list of image URLs from response
      final data = jsonDecode(response.body);
      return List<String>.from(data['photos'].map((photo) => photo['src']['medium']));
    } catch (error) {
      // Handle errors during fetching Pexels data
      throw _createFetchException(error, 'Pexels image data');
    }
  }

  /// Fetches playlists from the backend (potentially similar to Freesound music).
  static Future<List<Music>> fetchPlaylists() async {
    // URL for Django backend endpoint for playlists
    final url = Uri.parse('${_baseApiUrl}music/');
    try {
      // Retrieve the stored authentication token from SharedPreferences
      final token = await _getToken();

      // Send a GET request to the Django API with the authorization token in headers
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Token $token',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 15));

      // Check for HTTP errors in the response
      _handleHttpError(response);

      // Decode JSON data and map it to a list of Music objects
      final data = jsonDecode(response.body);
      return List<Music>.from(data.map((song) => Music.fromJson(song)));
    } catch (error) {
      // Handle errors in fetching playlists
      throw _createFetchException(error, 'playlists');
    }
  }

  /// Registers a new user by sending username and password to the backend.
  static Future<void> registerUser(String username, String password) async {
    // URL for Django backend endpoint for registration
    final url = Uri.parse('${_baseApiUrl}register/');
    try {
      // Send a POST request to the backend with user data in JSON format
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'username': username, 'password': password}),
      ).timeout(const Duration(seconds: 10));

      // Check for HTTP errors in the response
      _handleHttpError(response);
    } catch (error) {
      // Handle errors in user registration
      throw _createFetchException(error, 'user registration');
    }
  }

  /// Logs in a user and stores the token locally if successful.
  static Future<void> loginUser(String username, String password) async {
    // URL for Django backend endpoint for login
    final url = Uri.parse('${_baseApiUrl}login/');
    try {
      // Send a POST request with login credentials in JSON format
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'username': username, 'password': password}),
      ).timeout(const Duration(seconds: 10));

      // Check for HTTP errors in the response
      _handleHttpError(response);

      // Parse the response JSON and store token if login is successful
      final responseData = jsonDecode(response.body);
      if (responseData.containsKey('token')) {
        await _storeToken(responseData['token']);
      } else {
        throw Exception('Login failed: Token not found in response');
      }
    } catch (error) {
      // Handle errors in user login
      throw _createFetchException(error, 'user login');
    }
  }

  /// Creates a standardized exception for API fetch errors, with specific error context.
  static Exception _createFetchException(dynamic error, String context) {
    if (error is http.ClientException) {
      return Exception('Network error while fetching $context: ${error.message}');
    } else if (error is TimeoutException) {
      return Exception('Request timed out while fetching $context. Please try again later.');
    } else {
      return Exception('Error fetching $context: ${error.toString()}');
    }
  }

  /// Stores the authentication token locally using SharedPreferences.
  static Future<void> _storeToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('authToken', token);
  }

  /// Retrieves the authentication token from SharedPreferences.
  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('authToken');
  }
}
