import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _errorMessage;
  bool _isLoading = false; // To track loading state

  Future<void> _registerUser() async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    // Validate input
    if (username.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'Please fill in all fields';
      });
      return;
    }

    // Additional validation could go here (e.g., username length, password strength)

    final url = 'http://127.0.0.1:8000/api/register/'; // Replace with your actual Django endpoint

    setState(() {
      _isLoading = true; // Start loading
      _errorMessage = null; // Reset error message
    });

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'username': username, 'password': password}),
      );

      if (response.statusCode == 201) {
        // Registration successful
        _usernameController.clear(); // Clear input fields
        _passwordController.clear();
        Navigator.of(context).pushReplacementNamed('/login');
      } else {
        // Handle server errors
        final responseData = json.decode(response.body);
        setState(() {
          _errorMessage = responseData['error'] ?? 'Failed to register';
        });
      }
    } catch (error) {
      setState(() {
        _errorMessage = 'Error: $error';
      });
    } finally {
      setState(() {
        _isLoading = false; // Stop loading
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            if (_errorMessage != null) 
              Text(
                _errorMessage!,
                style: TextStyle(color: Colors.red),
              ),
            const SizedBox(height: 20), // Space between elements
            ElevatedButton(
              onPressed: _isLoading ? null : _registerUser, // Disable button while loading
              child: _isLoading 
                  ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 2.0,
                    ) 
                  : const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
