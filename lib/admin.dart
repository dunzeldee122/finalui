import 'package:flutter/material.dart';
import 'login.dart';
import 'dbconnection.dart'; // Import your dbconnection.dart file

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  List<Map<String, dynamic>> userList = []; // List to store user data

  @override
  void initState() {
    super.initState();
    fetchUserList(); // Fetch user list when the page initializes
  }

  Future<void> fetchUserList() async {
    try {
      final conn = getDatabaseConnection();
      final results = await conn.query('SELECT * FROM user');

      setState(() {
        userList = results.map((row) => row.fields).toList();
      });
    } catch (e) {
      print('Error fetching user list: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Page'),
        automaticallyImplyLeading: false, // Remove the back button
      ),
      body: ListView.builder(
        itemCount: userList.length,
        itemBuilder: (context, index) {
          final userData = userList[index];
          return ListTile(
            title: Text('${userData['fname']} ${userData['lname']}'),
            subtitle: Text('Email: ${userData['email']}'),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                deleteUser(userData['uid']); // Delete user and associated pet info
              },
            ),
          );
        },
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20.0, left: 20.0), // Adjust the padding as needed
        child: FloatingActionButton.extended(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          },
          label: Text(''),
          icon: Icon(Icons.logout),
          backgroundColor: Colors.red, // Adjust the color as needed
        ),
      ),
    );
  }

  Future<void> deleteUser(int uid) async {
    try {
      final conn = getDatabaseConnection();
      await conn.query('DELETE FROM petinfo WHERE uid = ?', [uid]); // Delete associated pet info
      await conn.query('DELETE FROM user WHERE uid = ?', [uid]); // Delete user
      fetchUserList(); // Refresh user list after deletion
    } catch (e) {
      print('Error deleting user: $e');
    }
  }
}
