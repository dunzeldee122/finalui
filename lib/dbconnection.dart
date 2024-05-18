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

