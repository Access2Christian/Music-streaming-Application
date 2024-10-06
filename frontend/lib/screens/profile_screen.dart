import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  // TextEditingController instances for handling form input fields
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _genderController = TextEditingController();
  final _dobController = TextEditingController(); // Date of birth
  final _cityController = TextEditingController();
  final _countryController = TextEditingController();
  
  bool _isLoading = false; // Boolean flag to track loading state during save operation

  @override
  void initState() {
    super.initState();
    // Populating text fields with mock data (In actual implementation, replace with API data)
    _nameController.text = "Nanah Chris"; // Example user name
    _emailController.text = "Chris@example.com"; // Example email
    _genderController.text = "Male"; // Example gender
    _dobController.text = "01-01-1990"; // Example date of birth
    _cityController.text = "Lagos"; // Example city
    _countryController.text = "Nigeria"; // Example country
  }

  // This function simulates saving the profile data. In a real app, it would involve API requests.
  Future<void> _saveProfile() async {
    setState(() {
      _isLoading = true; // Begin showing the loading indicator when save starts
    });
    
    // Simulate a delay to mimic a real network call (Replace with actual API call)
    await Future.delayed(const Duration(seconds: 2));

    // Check if the widget is still mounted before using context
    if (!mounted) return;

    setState(() {
      _isLoading = false; // Stop showing the loading indicator when save ends
    });

    // Display success message using BuildContext, only if the widget is still mounted
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profile updated successfully!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: const Color(0xFF4A90E2), // Soft blue AppBar color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Padding around all screen contents
        child: ListView( // ListView used to enable scrolling in case of long content
          children: [
            const Icon(
              Icons.person, // Icon at the top representing user profile
              size: 100, // Size of the icon
              color: Color(0xFF4A90E2), // Soft blue color for the icon
            ),
            const SizedBox(height: 20), // Vertical space between the icon and the first text field

            // Name input field
            TextField(
              controller: _nameController, // Binds input field to _nameController
              decoration: const InputDecoration(
                labelText: "Name", // Label for the input field
                labelStyle: TextStyle(color: Color(0xFF4A90E2)), // Soft blue label text color
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF4A90E2)), // Blue border when not focused
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF5A4D3A)), // Darker brown border when focused
                ),
              ),
            ),
            const SizedBox(height: 10), // Spacing between input fields

            // Email input field
            TextField(
              controller: _emailController, // Binds input field to _emailController
              decoration: const InputDecoration(
                labelText: "Email",
                labelStyle: TextStyle(color: Color(0xFF4A90E2)), // Soft blue label
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF4A90E2)), // Blue border when not focused
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF5A4D3A)), // Darker brown border when focused
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Gender input field
            TextField(
              controller: _genderController, // Binds input field to _genderController
              decoration: const InputDecoration(
                labelText: "Gender",
                labelStyle: TextStyle(color: Color(0xFF4A90E2)),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF4A90E2)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF5A4D3A)),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Date of Birth input field
            TextField(
              controller: _dobController, // Binds input field to _dobController
              decoration: const InputDecoration(
                labelText: "Date of Birth",
                labelStyle: TextStyle(color: Color(0xFF4A90E2)),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF4A90E2)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF5A4D3A)),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // City input field
            TextField(
              controller: _cityController, // Binds input field to _cityController
              decoration: const InputDecoration(
                labelText: "City",
                labelStyle: TextStyle(color: Color(0xFF4A90E2)),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF4A90E2)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF5A4D3A)),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Country input field
            TextField(
              controller: _countryController, // Binds input field to _countryController
              decoration: const InputDecoration(
                labelText: "Country",
                labelStyle: TextStyle(color: Color(0xFF4A90E2)),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF4A90E2)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF5A4D3A)),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Save button with improved style
            ElevatedButton(
              onPressed: _isLoading ? null : _saveProfile, // Disable button if loading
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4A90E2), // Soft blue button background
                padding: const EdgeInsets.symmetric(
                  vertical: 16.0, horizontal: 32.0), // Padding to make the button more clickable
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0), // Rounded corners for the button
                ),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ) // Shows a loading spinner if data is being saved
                  : const Text(
                      "Save Changes", // Button text
                      style: TextStyle(
                        fontSize: 18, // Larger font size for visibility
                        color: Colors.white, // Ensures text is readable on blue background
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
