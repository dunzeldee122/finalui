import 'dart:typed_data';
import 'package:mysql1/mysql1.dart';

late MySqlConnection _connection;
//connection
Future<void> initializeDatabase() async {
  final settings = ConnectionSettings(
    host: '192.168.0.31',
    port: 3306,
    user: 'test',
    password: '123',
    db: 'pet',
  );

  try {
    _connection = await MySqlConnection.connect(settings);
    print('Connected to the database');
  } catch (e) {
    print('Error: $e');
    rethrow;
  }
}

MySqlConnection getDatabaseConnection() {
  return _connection;
}
//query to call


//petregister
Future<void> registerPet({
  required int userId,
  required String name,
  required String type,
  required String breed,
  required String trait,
  required String color,
  required int age,
  required int price,
  required Uint8List petImage,
}) async {
  try {
    final conn = getDatabaseConnection();

    await conn.query(
      'INSERT INTO petinfo (uid, name, type, breed, trait, color, age, price, petimg) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)',
      [
        userId,
        name,
        type,
        breed,
        trait,
        color,
        age,
        price,
        petImage,
      ],
    );

    print('Pet registered successfully');
  } catch (e) {
    print('Error registering pet: $e');
    rethrow;
  }
}

Future<void> disposeDatabase() async {
  await _connection.close();
  print('Database connection closed');
}


//fetching user data
Future<Map<String, dynamic>> getUserData(int uid) async {
  final conn = getDatabaseConnection();

  try {
    final results = await conn.query(
      'SELECT fname, lname, phone, email, address FROM user WHERE uid = ?',
      [uid],
    );

    if (results.isNotEmpty) {
      final userData = results.first.fields;
      return {
        'fname': userData['fname'] ?? '',
        'lname': userData['lname'] ?? '',
        'phone': userData['phone'] ?? '',
        'email': userData['email'] ?? '',
        'address': userData['address'] ?? '',
      };
    }
    return {};
  } catch (e) {
    print('Error fetching user data: $e');
    rethrow;
  }
}
//fetching pets info
Future<List<Map<String, dynamic>>> getUserPets(int uid) async {
  final conn = getDatabaseConnection();

  try {
    final results = await conn.query(
      'SELECT name, type, breed, trait, color, age, price, petimg FROM petinfo WHERE uid = ?',
      [uid],
    );

    return results.map((row) {
      final fields = row.fields;
      return {
        'name': fields['name'],
        'type': fields['type'],
        'breed': fields['breed'],
        'trait': fields['trait'],
        'color': fields['color'],
        'age': fields['age'],
        'price': fields['price'],
        'petimg': fields['petimg'] as Uint8List?,
      };
    }).toList();
  } catch (e) {
    print('Error fetching user pets: $e');
    rethrow;
  }

  //fetching searched pet
}
Future<List<Map<String, dynamic>>> fetchFilteredPets(String query) async {
  final conn = getDatabaseConnection();

  try {
    final results = await conn.query(
      'SELECT name, type, breed, trait, color, age, price, petimg FROM petinfo WHERE type LIKE ? OR breed LIKE ?',
      ['%$query%', '%$query%'],
    );

    return results.map((row) {
      final fields = row.fields;
      final petImageBlob = fields['petimg'] as Blob?;
      final petImageData = petImageBlob?.toBytes() ?? Uint8List(0);
      return {
        'name': fields['name'],
        'type': fields['type'],
        'breed': fields['breed'],
        'trait': fields['trait'],
        'color': fields['color'],
        'age': fields['age'],
        'price': fields['price'],
        'petimg': petImageData,
      };
    }).toList();
  } catch (e) {
    print('Error fetching filtered pets: $e');
    return [];
  }


  //fetching user phone number to display
}

Future<String> fetchUserPhone(int userId) async {
  try {
    final conn = await getDatabaseConnection();
    final result = await conn.query('SELECT phone FROM user WHERE uid = ?', [userId]);
    if (result.isNotEmpty) {
      final phone = result.first.fields['phone'] ?? '';
      print('Phone number found: $phone');
      return phone;
    } else {
      print('No phone number found for user ID: $userId');
      return '';
    }
  } catch (e) {
    print('Error fetching user phone: $e');
    return '';
  }
}
