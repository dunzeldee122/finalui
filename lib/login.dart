import 'package:flutter/material.dart';
import 'register.dart';
import 'home.dart';
import 'dbconnection.dart'; // Import dbconnection.dart to access the loginUser function

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
            image: AssetImage('assets/loginbg.jpg'), // Adjust the path to your image asset
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Your logo
                Image.asset(
                  'assets/logo.png',
                  width: 100, // Adjust width as needed
                  height: 100, // Adjust height as needed
                ),
                const SizedBox(height: 20.0),
                // Text field for username
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
                // Text field for password
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
                // Log in button
                ElevatedButton(
                  onPressed: () async {
                    // Get the text entered in the username and password fields
                    String username = un.text.trim();
                    String password = pw.text.trim();

                    // Check if the username and password are not empty
                    if (username.isNotEmpty && password.isNotEmpty) {
                      // Call the loginUser function from dbconnection.dart
                      bool isLoggedIn = await loginUser(username, password);
                      if (isLoggedIn) {
                        // Redirect to HomePage if login is successful
                        Navigator.pushReplacementNamed(context, '/home');
                      } else {
                        // Show an error message if login fails
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Invalid username or password.'),
                        ));
                      }
                    } else {
                      // Show an error message if username or password is empty
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Please enter username and password.'),
                      ));
                    }
                  },
                  child: const Text('Log In'),
                ),
                const SizedBox(height: 20.0),
                // "Don't have an account? Sign up" text
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
      backgroundColor: Colors.transparent, // Set background color to transparent
    );
  }
}
