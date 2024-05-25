// main.dart

import 'package:flutter/material.dart';
import 'login.dart';
import 'home.dart';
import 'register.dart';
import 'profile.dart';
import 'petreg.dart';
import 'admin.dart';
import 'petlist.dart';
import 'purchased.dart';
import 'petdetails.dart' as details; // Use alias 'details'
import 'dbconnection.dart'; // Import dbconnection.dart to initialize the database connection

void main() async {
  // Initialize the database connection before running the app
  await initializeDatabase();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  get userData => null;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/home': (context) => HomePage(userData: userData),
        '/register': (context) => RegisterPage(),
        '/profile': (context) => ProfilePage(userData: {}, userId: null,),
        '/petregistration': (context) => PetRegistrationPage(userData: {},),
        '/admin': (context) => AdminPage(),
        '/petlist': (context) => PetList(user: '',),
        '/purchased': (context) => PurchasedPage(userId: userData['uid']),

        '/petdetails': (context) => details.PetDetailsPage(petData: {}, userId: userData['uid']),

        // Use 'details' alias
      },
    );
  }
}
