import 'package:mysql1/mysql1.dart';
import 'package:flutter_bcrypt/flutter_bcrypt.dart';

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

Future<void> registerUser(String username, String password, String firstName, String lastName, String phoneNumber, String email, String address) async {
  final conn = getDatabaseConnection();

  try {
    String hashedPassword = await hashPassword(password);
    String createUserQuery = 'INSERT INTO user (username, password, fname, lname, phone, email, address) VALUES (?, ?, ?, ?, ?, ?, ?)';

    await conn.query(createUserQuery, [username, hashedPassword, firstName, lastName, phoneNumber, email, address]);
    print('User registered successfully');
  } catch (e) {
    print('Error during user registration: $e');
    rethrow;
  }
}

Future<bool> loginUser(String username, String password) async {
  final conn = getDatabaseConnection();

  try {
    String loginQuery = 'SELECT * FROM user WHERE username = ?';
    var results = await conn.query(loginQuery, [username]);

    if (results.isNotEmpty) {
      String storedPassword = results.first['password'];
      bool passwordMatch = await checkPassword(password, storedPassword);

      if (passwordMatch) {
        print('Login successful for user: $username');
        return true;
      }
    }

    print('Login failed for user: $username');
    return false;
  } catch (e) {
    print('Error during login: $e');
    return false;
  }
}

Future<String> hashPassword(String password) async {
  String salt = await FlutterBcrypt.salt();
  String hashedPassword = await FlutterBcrypt.hashPw(password: password, salt: salt);
  return hashedPassword;
}

Future<bool> checkPassword(String password, String hashedPassword) async {
  return await FlutterBcrypt.verify(password: password, hash: hashedPassword);
}
