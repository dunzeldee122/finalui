import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'dbconnection.dart';
import 'home.dart';
import 'register.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController un = TextEditingController();
  final TextEditingController pw = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final transparentColor = const Color.fromRGBO(166, 123, 91, 0.5);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: const DecorationImage(
            image: AssetImage('assets/loginbg.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/logo.png',
                  width: 100,
                  height: 100,
                ),
                const SizedBox(height: 20.0),
                TextField(
                  controller: un,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    filled: true,
                    fillColor: transparentColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                  ),
                ),
                const SizedBox(height: 20.0),
                TextField(
                  controller: pw,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    filled: true,
                    fillColor: transparentColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () async {
                    await initializeDatabase();
                    String username = un.text.trim();
                    String password = pw.text.trim();

                    if (username.isNotEmpty && password.isNotEmpty) {
                      Map<String, dynamic> userData = await loginUser(username, password);
                      if (userData.isNotEmpty) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage(userData: userData)),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Invalid username or password.'),
                        ));
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Please enter username and password.'),
                      ));
                    }
                  },
                  child: const Text('Log In'),
                ),
                const SizedBox(height: 20.0),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterPage()),
                    );
                  },
                  child: RichText(
                    text: const TextSpan(
                      text: 'Don\'t have an account? ',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(
                          text: 'Sign up',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
    );
  }

  Future<Map<String, dynamic>> loginUser(String username, String password) async {
    try {
      final conn = getDatabaseConnection();

      // Retrieve user data from the database based on the provided username and password
      final results = await conn.query(
        'SELECT uid, fname, lname, phone, email, address FROM user WHERE username = ? AND password = ?',
        [username, md5.convert(utf8.encode(password)).toString()],
      );

      if (results.isNotEmpty) {
        final userData = results.first.fields;
        return {
          'uid': userData['uid'],
          'fname': userData['fname'],
          'lname': userData['lname'],
          'phone': userData['phone'],
          'email': userData['email'],
          'address': userData['address'],
        };
      }

      return {}; // Return an empty map if no user found
    } catch (e) {
      print('Error during login: $e');
      return {};
    }
  }
}
