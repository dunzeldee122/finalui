import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'login.dart'; // Import the login page
import 'petreg.dart'; // Import the pet registration page

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? _selectedImage;

  Future<void> _getImageFromGallery() async {
    final pickedFile = await ImagePicker.platform.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _showLogoutConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to log out?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                // Navigate back to the login screen
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            // Profile icon or selected image
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20.0),
              color: Colors.blue,
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white,
                child: _selectedImage != null
                    ? Image.file(_selectedImage!, fit: BoxFit.cover) // Use selected image if available
                    : Icon(
                  Icons.account_circle,
                  size: 80,
                  color: Colors.blue,
                ), // Default icon if no image selected
              ),
            ),
            // Option to change profile picture
            ListTile(
              title: Text('Change Profile Picture'),
              onTap: _getImageFromGallery,
            ),
            // Button to list your pet
            ListTile(
              title: Text('List Your Pet'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => PetRegistrationPage()));
              },
            ),
            // Logout button
            Expanded( // Use Expanded to push the logout button to the bottom
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ListTile(
                  title: Text('Logout'),
                  onTap: () {
                    _showLogoutConfirmationDialog(context);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: Text('Home Page'),
      ),
    );
  }
}
