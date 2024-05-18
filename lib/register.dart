import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'dbconnection.dart';
import 'login.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final transparentColor = const Color.fromRGBO(166, 123, 91, 0.5);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
          children: [
      Container(
      decoration: const BoxDecoration(
      image: DecorationImage(
          image: AssetImage("assets/uregbg.jpg"),
      fit: BoxFit.cover,
    ),
    ),
    ),
    Padding(
    padding: const EdgeInsets.fromLTRB(20.0, 100.0, 20.0, 20.0),
    child: SingleChildScrollView(
    child: Center(
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
    TextField(
    controller: usernameController,
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
    const SizedBox(height: 10),
    TextField(
    controller: passwordController,
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
    const SizedBox(height: 10),
    TextField(
    controller: firstNameController,
    decoration: InputDecoration(
    labelText: 'First Name',
    filled: true,
    fillColor: transparentColor,
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.0),
    borderSide: BorderSide.none,
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
    ),
    ),
    const SizedBox(height: 10),
    TextField(
    controller: lastNameController,
    decoration: InputDecoration(
      labelText: 'Last Name',
      filled: true,
      fillColor: transparentColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
    ),
    ),
      const SizedBox(height: 10),
      TextField(
        controller: phoneNumberController,
        decoration: InputDecoration(
          labelText: 'Phone Number',
          filled: true,
          fillColor: transparentColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
        ),
      ),
      const SizedBox(height: 10),
      TextField(
        controller: emailController,
        decoration: InputDecoration(
          labelText: 'Email',
          filled: true,
          fillColor: transparentColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
        ),
      ),
      const SizedBox(height: 10),
      TextField(
        controller: addressController,
        decoration: InputDecoration(
          labelText: 'Address',
          filled: true,
          fillColor: transparentColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
        ),
      ),
      const SizedBox(height: 20),
      Container(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () async {
            String username = usernameController.text.trim();
            String password = passwordController.text.trim();
            String firstName = firstNameController.text.trim();
            String lastName = lastNameController.text.trim();
            String phoneNumber = phoneNumberController.text.trim();
            String email = emailController.text.trim();
            String address = addressController.text.trim();

            if (username.isNotEmpty && password.isNotEmpty) {
              // Hash the password using MD5
              String hashedPassword = md5.convert(utf8.encode(password)).toString();

              // Store the password hash
              await registerUser(username, hashedPassword, firstName, lastName, phoneNumber, email, address);

              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Success'),
                    content: const Text('Account has been created.'),
                    actions: <Widget>[
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => LoginPage()),
                          );
                        },
                        child: const Text('Close'),
                      ),
                    ],
                  );
                },
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Please enter username and password.'),
              ));
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.brown,
          ),
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: Text(
              'Register',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    ],
    ),
    ),
    ),
    ),
          ],
      ),
    );
  }
}
Future<void> registerUser(String username, String hashedPassword, String firstName, String lastName, String phoneNumber, String email, String address) async {
  final conn = getDatabaseConnection();

  try {
    String createUserQuery = 'INSERT INTO user (username, password, fname, lname, phone, email, address) VALUES (?, ?, ?, ?, ?, ?, ?)';

    await conn.query(createUserQuery, [username, hashedPassword, firstName, lastName, phoneNumber, email, address]);
    print('User registered successfully');
  } catch (e) {
    print('Error during user registration: $e');
    rethrow;
  }
}