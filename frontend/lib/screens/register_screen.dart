import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Controllers to manage input fields
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _errorMessage; // For displaying error messages
  bool _isLoading = false; // Tracks loading state during registration

  // Function to register user with the backend
  Future<void> _registerUser() async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    // Validate input fields
    if (username.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'Please fill in all fields';
      });
      return;
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
        body: json.encode({'username': username, 'password': password}),
      );

      // Check for successful registration
      if (response.statusCode == 201) {
        _usernameController.clear();
        _passwordController.clear();
        Navigator.of(context).pushReplacementNamed('/login'); // Navigate to login
      } else {
        // Extract error message from response
        final responseData = json.decode(response.body);
        setState(() {
          _errorMessage = responseData['error'] ?? 'Failed to register';
        });
      }
    } catch (error) {
      // Handle error case
      setState(() {
        _errorMessage = 'Error: $error';
      });
    } finally {
      // Stop loading spinner
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Light gray background
      appBar: AppBar(
        title: const Text('Register'),
        backgroundColor: const Color(0xFF4A90E2), // Soft blue app bar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Username input field
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
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
            ),
            const SizedBox(height: 16), // Space between input fields

            // Password input field
            TextField(
              controller: _passwordController,
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
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  _errorMessage!,
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
                padding: const EdgeInsets.symmetric(vertical: 14.0), // Adjust padding
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 2.0, // Spinner inside button
                    )
                  : const Text(
                      'Register', 
                      style: TextStyle(fontSize: 18, color: Colors.white), // Button text
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
