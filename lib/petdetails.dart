import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:meowdoption/dbconnection.dart';

class PetDetailsPage extends StatelessWidget {
  final Map<String, dynamic> petData;
  final int userId; //parameter to pass the user ID

  const PetDetailsPage({Key? key, required this.petData, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MemoryImage? petImage = petData['petimg'] != null
        ? MemoryImage(Uint8List.fromList((petData['petimg'] as Blob).toBytes()))
        : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pet Details'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {

          await Future.delayed(Duration(seconds: 1));
          return;
        },
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/pawbg.jpg'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (petImage != null)
                          Image(image: petImage)
                        else
                          const Image(image: AssetImage('assets/placeholder.jpg')),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Name: ${petData['name']}',
                                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.normal),
                              ),
                              Text(
                                'Type: ${petData['type']}',
                                style: const TextStyle(fontSize: 20),
                              ),
                              Text(
                                'Breed: ${petData['breed']}',
                                style: const TextStyle(fontSize: 20),
                              ),
                              Text(
                                'Trait: ${petData['trait']}',
                                style: const TextStyle(fontSize: 20),
                              ),
                              Text(
                                'Color: ${petData['color']}',
                                style: const TextStyle(fontSize: 20),
                              ),
                              Text(
                                'Age: ${petData['age']}',
                                style: const TextStyle(fontSize: 20),
                              ),
                              Text(
                                'Price: \$${petData['price']}',
                                style: const TextStyle(fontSize: 20),
                              ),
                              const SizedBox(height: 10),
                              FutureBuilder<Map<String, dynamic>>(
                                future: fetchUserInfo(petData['uid']),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return const CircularProgressIndicator();
                                  } else if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  } else {
                                    final userData = snapshot.data ?? {};
                                    final name = '${userData['fname']} ${userData['lname']}';
                                    final address = userData['address'];
                                    final phone = userData['phone'];
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Owner Name: $name',
                                          style: const TextStyle(fontSize: 20),
                                        ),
                                        Text(
                                          'Address: $address',
                                          style: const TextStyle(fontSize: 20),
                                        ),
                                        Text(
                                          'Phone: $phone',
                                          style: const TextStyle(fontSize: 20),
                                        ),
                                      ],
                                    );
                                  }
                                },
                              ),
                              const SizedBox(height: 20),
                              Center(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color.fromRGBO(166, 123, 91, 0.5),
                                  ),
                                  onPressed: () async {
                                    try {
                                      final conn = await getDatabaseConnection();
                                      final result = await conn.query('''
                                        INSERT INTO purchased (user_id, pet_id, price)
                                        VALUES (?, ?, ?)
                                      ''', [userId, petData['pui'], petData['price']]);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Purchase Successful'),
                                        ),
                                      );
                                    } catch (e) {
                                      print('Error purchasing pet: $e');
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar (
                                          content: Text('Failed to purchase pet. Please try again later.'),
                                        ),
                                      );
                                    }
                                  },
                                  child: Text(
                                    petData['price'] > 0 ? 'Buy' : 'Adopt',
                                    style: TextStyle(fontSize: 18, color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Map<String, dynamic>> fetchUserInfo(int userId) async {
    try {
      final conn = await getDatabaseConnection();
      final result = await conn.query('SELECT fname, lname, address, phone FROM user WHERE uid = ?', [userId]);
      if (result.isNotEmpty) {
        return result.first.fields;
      } else {
        return {};
      }
    } catch (e) {
      print('Error fetching user info: $e');
      return {};
    }
  }
}
