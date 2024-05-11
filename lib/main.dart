import 'package:flutter/material.dart';
import 'login.dart';
import 'home.dart';
import 'register.dart';
import 'profile.dart';
import 'petreg.dart';
import 'package:mssql_connection/mssql_connection.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  void initializeDatabase() async{
    MssqlConnection mssqlConnection = MssqlConnection.getInstance();
    bool isConnected = await mssqlConnection.connect(
      ip: '192.168.0.31',
      port: '80',
      databaseName: 'pet',
      username: 'root',
      password: '',
      timeoutInSeconds: 15,
    );

  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/home': (context) => HomePage(),
        '/register': (context) => RegisterPage(),
        '/profile': (context) => ProfilePage(),
        '/petregistration': (context) => PetRegistrationPage(),
      },
    );
  }
}
