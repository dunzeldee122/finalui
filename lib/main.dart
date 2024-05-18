import 'package:flutter/material.dart';
import 'login.dart';
import 'home.dart';
import 'register.dart';
import 'profile.dart';
import 'petreg.dart';
import 'admin.dart';
import 'petlist.dart';
import 'newinfo.dart';
import 'package:mssql_connection/mssql_connection.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
        '/admin': (context) => AdminPage(),
        '/petlist': (context) => PetList(user: '',),
        '/newinfo': (context) => NewInfoPage(),
      },
    );
  }

  void initializeDatabase() async {
    MssqlConnection mssqlConnection = MssqlConnection.getInstance();
    bool isConnected = await mssqlConnection.connect(
      ip: '192.168.0.31',
      port: '3306',
      databaseName: 'pet',
      username: 'root',
      password: '',
      timeoutInSeconds: 15,
    );

    if (isConnected) {
      // CRUD operations for the user table
      String createUserQuery =
          'INSERT INTO user (username, password, fname, lname, phone, email, address, userimg) VALUES (?, ?, ?, ?, ?, ?, ?, ?)';
      String readUserQuery = 'SELECT * FROM user WHERE uid = ?';
      String updateUserQuery =
          'UPDATE user SET username = ?, password = ?, fname = ?, lname = ?, phone = ?, email = ?, address = ?, userimg = ? WHERE uid = ?';
      String deleteUserQuery = 'DELETE FROM user WHERE uid = ?';

      // CRUD operations for the petinfo table
      String createPetQuery =
          'INSERT INTO petinfo (uid, name, type, breed, trait, color, age, price, petimg) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)';
      String readPetQuery = 'SELECT * FROM petinfo WHERE petuid = ?';
      String updatePetQuery =
          'UPDATE petinfo SET name = ?, type = ?, breed = ?, trait = ?, color = ?, age = ?, price = ?, petimg = ? WHERE petuid = ?';
      String deletePetQuery = 'DELETE FROM petinfo WHERE petuid = ?';

      // Example of executing a query
      await mssqlConnection.getData(readUserQuery).then((value) {
        print(value);
      });
    }
  }
}
