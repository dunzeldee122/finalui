import 'package:flutter/material.dart';
import 'home.dart'; // Import home.dart to navigate to home page

class AdminPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Page'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 16), // Add padding to the top of the first ListTile
              child: ListTile(
                title: Text('Home'),
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/home'); // Navigate to home page
                },
              ),
            ),
            ListTile(
              title: Text('Logout'),
              onTap: () {
                // Add your logout logic here
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Text('This is the Admin Page'),
      ),
    );
  }
}
