import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  // Controllers to manage input fields
  final _usernameController = TextEditingController(); // Updated to username
  final _passwordController = TextEditingController(); // Password controller
  String? _errorMessage; // For displaying error messages
  bool _isLoading = false; // Tracks loading state during registration

  // Function to register user with the backend
  Future<void> _registerUser() async {
    final username = _usernameController.text; // Get username input
    final password = _passwordController.text; // Get password input

    // Validate input fields
    if (username.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'Please fill in all fields'; // Set error message
      });
      return; // Exit if fields are empty
    }

    const url = 'http://127.0.0.1:8000/api/register/'; // Backend API endpoint

    setState(() {
      _isLoading = true; // Start loading spinner
      _errorMessage = null; // Reset error message
    });

    try {
      // Send POST request to register user
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'username': username, 'password': password}), // Use username and password
      );

      // Check for successful registration
      if (response.statusCode == 201) {
        _usernameController.clear(); // Clear username input field
        _passwordController.clear(); // Clear password input field
        if (!mounted) return; // Check if the widget is still mounted
        Navigator.of(context).pushReplacementNamed('/login'); // Navigate to login
      } else {
        // Extract error message from response
        final responseData = json.decode(response.body);
        setState(() {
          _errorMessage = responseData['error'] ?? 'Failed to register'; // Set error message
        });
      }
    } catch (error) {
      // Handle error case
      setState(() {
        _errorMessage = 'Error: $error'; // Set error message
      });
    } finally {
      // Stop loading spinner
      if (mounted) {
        setState(() {
          _isLoading = false; // Stop loading spinner
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Light gray background
      appBar: AppBar(
        title: const Text('Register'), // App bar title
        backgroundColor: const Color(0xFF4A90E2), // Soft blue app bar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Padding for the body
        child: Column(
          children: [
            // Username input field
            TextField(
              controller: _usernameController, // Controller for username input
              decoration: const InputDecoration(
                labelText: 'Username', // Changed to Username
                labelStyle: TextStyle(color: Color(0xFF4A90E2)), // Soft blue label color
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF4A90E2)), // Soft blue border
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF003366)), // Darker blue on focus
                ),
                filled: true,
                fillColor: Color(0xFFE0E0E0), // Light gray background for input
              ),
              keyboardType: TextInputType.text, // Set keyboard type to text
            ),
            const SizedBox(height: 16), // Space between input fields

            // Password input field
            TextField(
              controller: _passwordController, // Controller for password input
              decoration: const InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(color: Color(0xFF4A90E2)), // Soft blue label color
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF4A90E2)), // Soft blue border
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF003366)), // Darker blue on focus
                ),
                filled: true,
                fillColor: Color(0xFFE0E0E0), // Light gray background for input
              ),
              obscureText: true, // Hide password input
            ),

            // Display error message if any
            if (_errorMessage != null) // Check if there is an error message
              Padding(
                padding: const EdgeInsets.only(top: 8.0), // Space above error message
                child: Text(
                  _errorMessage!, // Show error message
                  style: const TextStyle(color: Colors.red), // Error text color
                ),
              ),

            const SizedBox(height: 20), // Space before button

            // Register button
            ElevatedButton(
              onPressed: _isLoading ? null : _registerUser, // Disable button when loading
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4A90E2), // Soft blue button color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0), // Rounded corners for button
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 40, // Horizontal padding
                  vertical: 14.0, // Adjust padding
                ),
              ),
              child: _isLoading // Show loading indicator or button text
                  ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white), // Spinner color
                      strokeWidth: 2.0, // Spinner width
                    )
                  : const Text(
                      'Register', // Button text
                      style: TextStyle(fontSize: 18, color: Colors.white), // Button text style
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
