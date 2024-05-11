import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'home.dart';

class PetRegistrationPage extends StatefulWidget {
  @override
  _PetRegistrationPageState createState() => _PetRegistrationPageState();
}

class _PetRegistrationPageState extends State<PetRegistrationPage> {
  File? _imageFile; // Variable to store selected image file

  // Function to pick an image from gallery
  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      }
    });
  }

  // Function to handle registration
  void _registerPet(BuildContext context) {
    // Show pop-up message
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pet Listed for Adoption'),
          content: Text('Your pet has been listed for adoption.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()), // Navigate to home.dart
                );
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // Extend body behind AppBar
      appBar: AppBar(
        title: Text('Pet Registration'),
        backgroundColor: Colors.transparent, // Make AppBar transparent
        elevation: 0, // Remove AppBar shadow
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/profilebg.jpg'), // Background image path
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          fit: StackFit.expand, // Make Stack children fill the entire space
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 120.0, 20.0, 20.0), // Add top padding
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      style: TextStyle(color: Colors.white), // Change text color to white
                      decoration: InputDecoration(
                        labelText: 'Name',
                        filled: true,
                        fillColor: Color(0xFFa67b5b), // Transparent background color
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      style: TextStyle(color: Colors.white), // Change text color to white
                      decoration: InputDecoration(
                        labelText: 'Type',
                        filled: true,
                        fillColor: Color(0xFFa67b5b), // Transparent background color
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      style: TextStyle(color: Colors.white), // Change text color to white
                      decoration: InputDecoration(
                        labelText: 'Breed',
                        filled: true,
                        fillColor: Color(0xFFa67b5b), // Transparent background color
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      style: TextStyle(color: Colors.white), // Change text color to white
                      decoration: InputDecoration(
                        labelText: 'Trait',
                        filled: true,
                        fillColor: Color(0xFFa67b5b), // Transparent background color
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      style: TextStyle(color: Colors.white), // Change text color to white
                      decoration: InputDecoration(
                        labelText: 'Color',
                        filled: true,
                        fillColor: Color(0xFFa67b5b), // Transparent background color
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      style: TextStyle(color: Colors.white), // Change text color to white
                      decoration: InputDecoration(
                        labelText: 'Age',
                        filled: true,
                        fillColor: Color(0xFFa67b5b), // Transparent background color
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      style: TextStyle(color: Colors.white), // Change text color to white
                      decoration: InputDecoration(
                        labelText: 'Price',
                        filled: true,
                        fillColor: Color(0xFFa67b5b), // Transparent background color
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        // Open image picker dialog
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Select Image'),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: [
                                    GestureDetector(
                                      child: Text('Take a picture', style: TextStyle(color: Colors.black)), // Change text color to white
                                      onTap: () {
                                        _pickImage(ImageSource.camera);
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    SizedBox(height: 20),
                                    GestureDetector(
                                      child: Text('Choose from gallery', style: TextStyle(color: Colors.black)), // Change text color to white
                                      onTap: () {
                                        _pickImage(ImageSource.gallery);
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFa67b5b), // Same color as text field
                      ),
                      child: Text('Select an Image', style: TextStyle(color: Colors.white)), // Change text color to white
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        _registerPet(context); // Call function to register pet
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFa67b5b), // Same color as text field
                      ),
                      child: Text('Register', style: TextStyle(color: Colors.white)), // Change text color to white
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
