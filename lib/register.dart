import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'dbconnection.dart';
import 'login.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  String? usernameError;
  String? passwordError;
  String? firstNameError;
  String? lastNameError;
  String? phoneNumberError;
  String? emailError;
  String? addressError;
  bool _isPasswordVisible = false;

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
                        hintText: 'Username',
                        filled: true,
                        fillColor: transparentColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                        errorText: usernameError,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        filled: true,
                        fillColor: transparentColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                        errorText: passwordError,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                      obscureText: !_isPasswordVisible,
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: firstNameController,
                      decoration: InputDecoration(
                        hintText: 'First Name',
                        filled: true,
                        fillColor: transparentColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                        errorText: firstNameError,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: lastNameController,
                      decoration: InputDecoration(
                        hintText: 'Last Name',
                        filled: true,
                        fillColor: transparentColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                        errorText: lastNameError,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: phoneNumberController,
                      decoration: InputDecoration(
                        hintText: 'Phone Number',
                        filled: true,
                        fillColor: transparentColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                        errorText: phoneNumberError,
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: 'Email',
                        filled: true,
                        fillColor: transparentColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                        errorText: emailError,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: addressController,
                      decoration: InputDecoration(
                        hintText: 'Address',
                        filled: true,
                        fillColor: transparentColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                        errorText: addressError,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            usernameError = usernameController.text.length < 6 ? 'Username should be at least 6 characters long' : null;
                            passwordError = passwordController.text.length < 6 ? 'Password should be at least 6 characters long' : null;
                            firstNameError = RegExp(r'^[a-zA-Z]+$').hasMatch(firstNameController.text) ? null : 'Enter a valid name';
                            lastNameError = RegExp(r'^[a-zA-Z]+$').hasMatch(lastNameController.text) ? null : 'Enter a valid name';
                            phoneNumberError = phoneNumberController.text.length == 11 ? null : 'Enter a valid number';
                            emailError = emailController.text.endsWith('.com') ? null : 'Enter a valid email';
                            addressError = addressController.text.isNotEmpty ? null : 'This field cannot be empty';
                          });

                          if (usernameError == null &&
                              passwordError == null &&
                              firstNameError == null &&
                              lastNameError == null &&
                              phoneNumberError == null &&
                              emailError == null &&
                              addressError == null) {
                            String username = usernameController.text.trim();
                            String password = passwordController.text.trim();
                            String firstName = firstNameController.text.trim();
                            String lastName = lastNameController.text.trim();
                            String phoneNumber = phoneNumberController.text.trim();
                            String email = emailController.text.trim();
                            String address = addressController.text.trim();

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
}
