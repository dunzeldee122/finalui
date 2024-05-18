//pet that the user listed

import 'package:flutter/material.dart';

class PetList extends StatelessWidget {
  final String user;

  // Constructor to receive the user name
  PetList({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pet List for $user'), // Show user name in the app bar
      ),
      body: Center(
        child: Text('Pet List for $user'), // Display user name in the body
      ),
    );
  }
}
