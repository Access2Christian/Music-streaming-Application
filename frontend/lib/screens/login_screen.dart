import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _errorMessage;
  bool _isLoading = false; // State to track loading

  Future<void> _loginUser() async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    // Validate input
    if (username.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'Please fill in all fields';
      });
      return;
    }

    final url = 'http://127.0.0.1:8000/api/login/'; // Replace with your actual Django endpoint

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

      setState(() {
        _isLoading = false; // Stop loading
      });

      if (response.statusCode == 200) {
        // Login successful, navigate to home screen or wherever needed
        Navigator.of(context).pushReplacementNamed('/home');
      } else {
        // Handle server errors
        final responseData = json.decode(response.body);
        setState(() {
          _errorMessage = responseData['error'] ?? 'Failed to login';
        });
      }
    } catch (error) {
      setState(() {
        _isLoading = false; // Stop loading
        _errorMessage = 'Error: $error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
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
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  _errorMessage!,
                  style: TextStyle(color: Colors.red),
                ),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _loginUser, // Disable button while loading
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white) // Show loading indicator
                  : const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
