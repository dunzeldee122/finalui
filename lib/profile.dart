import 'package:flutter/material.dart';
import 'petreg.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/petregistration');
              },
              child: Text('List Your Pet'),
            ),
          ],
        ),
      ),
    );
  }
}
