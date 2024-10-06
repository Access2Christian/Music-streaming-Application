import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Import HTTP package for making API requests
import 'dart:convert'; // Import for encoding and decoding JSON

// The LoginScreen widget represents the login screen of the app.
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key); // Constructor for LoginScreen

  @override
  LoginScreenState createState() => LoginScreenState(); // Create state for managing the screen's state
}

// This class handles the internal state and behavior for the login screen.
class LoginScreenState extends State<LoginScreen> {
  // Controllers to manage input fields for username and password.
  final _usernameController = TextEditingController(); // Controller for the username input field
  final _passwordController = TextEditingController(); // Controller for the password input field
  String? _errorMessage; // Variable to store error messages
  bool _isLoading = false; // State variable to track if a login request is in progress

  // This method handles the login action by making an HTTP POST request to the login API.
  Future<void> _loginUser() async {
    final username = _usernameController.text; // Get the username entered by the user
    final password = _passwordController.text; // Get the password entered by the user

    // Check if the username or password is empty
    if (username.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'Please fill in all fields'; // Set error message
      });
      return; // Exit if fields are empty
    }

    const url = 'http://127.0.0.1:8000/api/login/'; // API URL for user login

    setState(() {
      _isLoading = true; // Show loading indicator
      _errorMessage = null; // Clear previous error messages
    });

    try {
      // Send POST request to the API with the username and password as JSON
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'username': username, 'password': password}),
      );

      setState(() {
        _isLoading = false; // Stop showing the loading indicator
      });

      // If login is successful (status code 200), navigate to the home screen
      if (response.statusCode == 200) {
         if (!mounted) return; // Ensure widget is still mounted
        Navigator.of(context).pushReplacementNamed('/home');
      } else {
        final responseData = json.decode(response.body); // Parse response body
        setState(() {
          _errorMessage = responseData['error'] ?? 'Failed to login'; // Show error message
        });
      }
    } catch (error) {
      // Handle any errors during the login process
      setState(() {
        _isLoading = false; // Stop showing the loading indicator
        _errorMessage = 'Error: $error'; // Display the error message
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECEFF1), // Light background color
      body: Padding(
        padding: const EdgeInsets.all(24.0), // Padding for the form
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Center content vertically
              crossAxisAlignment: CrossAxisAlignment.center, // Center content horizontally
              children: [
                const Text(
                  'Welcome Back!', // Welcome message for the user
                  style: TextStyle(
                    fontSize: 32, // Large text size
                    fontWeight: FontWeight.bold, // Bold text
                    color: Color(0xFF4A90E2), // Blue color
                  ),
                ),
                const SizedBox(height: 32), // Space between the text and the input fields
                // Username input field
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username', // Label for username input
                    labelStyle: const TextStyle(color: Color(0xFF4A90E2)), // Label color
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFF4A90E2)), // Blue border when focused
                      borderRadius: BorderRadius.circular(12.0), // Rounded border
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0), // Default rounded border
                    ),
                    filled: true, // Filled background
                    fillColor: const Color(0xFFB0BEC5), // Light gray background
                  ),
                  style: const TextStyle(color: Colors.black), // Input text color
                ),
                const SizedBox(height: 16), // Space between the username and password fields
                // Password input field
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password', // Label for password input
                    labelStyle: const TextStyle(color: Color(0xFF4A90E2)), // Label color
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFF4A90E2)), // Blue border when focused
                      borderRadius: BorderRadius.circular(12.0), // Rounded border
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0), // Default rounded border
                    ),
                    filled: true, // Filled background
                    fillColor: const Color(0xFFB0BEC5), // Light gray background
                  ),
                  obscureText: true, // Hide password text for security
                  style: const TextStyle(color: Colors.black), // Input text color
                ),
                if (_errorMessage != null) // Check for an error message
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0), // Padding for error message
                    child: Text(
                      _errorMessage!, // Display error message
                      style: const TextStyle(color: Colors.red), // Red text for error
                    ),
                  ),
                const SizedBox(height: 32), // Space before the login button
                // Login button
                ElevatedButton(
                  onPressed: _isLoading ? null : _loginUser, // Disable button if loading
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4A90E2), // Blue button background
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0), // Rounded corners
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40, // Horizontal padding
                      vertical: 14, // Vertical padding
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator( // Show a loading spinner if logging in
                          color: Colors.white, // White spinner
                        )
                      : const Text(
                          'Login', // Button text
                          style: TextStyle(fontSize: 18, color: Colors.white), // White text
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
      // AppBar with back arrow and styling
      appBar: AppBar(
        title: const Text('Login'), // Title for the AppBar
        backgroundColor: const Color(0xFF4A90E2), // Same blue background as buttons
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), // Back arrow icon
          onPressed: () {
            Navigator.of(context).pop(); // Go back to the previous screen
          },
        ),
      ),
    );
  }
}
