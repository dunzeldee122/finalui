import 'package:mysql1/mysql1.dart';

late MySqlConnection _connection;

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

Future<Map<String, dynamic>> getUserData(int uid) async {
  final conn = getDatabaseConnection();

  try {
    final results = await conn.query(
        'SELECT fname, lname, phone, email, address FROM user WHERE uid = ?',
        [uid]);

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
    return {}; // Return an empty map if no user found
  } catch (e) {
    print('Error fetching user data: $e');
    rethrow;
  }
}
