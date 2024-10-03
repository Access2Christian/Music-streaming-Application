import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: const Color(0xFF4A90E2), // Soft blue app bar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile settings option
            ListTile(
              title: const Text("Profile"),
              leading: const Icon(Icons.person, color: Color(0xFF4A90E2)), // Soft blue icon color
              onTap: () {
                Navigator.of(context).pushNamed('/profile'); // Navigate to Profile
              },
            ),
            const Divider(color: Color(0xFFE0E0E0)), // Light gray divider for separation
            // Logout option
            ListTile(
              title: const Text("Logout"),
              leading: const Icon(Icons.logout, color: Color(0xFF4A90E2)), // Soft blue icon color
              onTap: () {
                // Handle logout logic
                Navigator.of(context).pushReplacementNamed('/login'); // Go back to login
              },
            ),
          ],
        ),
      ),
    );
  }
}

