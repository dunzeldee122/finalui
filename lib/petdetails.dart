import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:meowdoption/dbconnection.dart';
import 'package:mysql1/mysql1.dart';

class PetDetailsPage extends StatelessWidget {
  final Map<String, dynamic> petData;

  const PetDetailsPage({Key? key, required this.petData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MemoryImage? petImage = petData['petimg'] != null
        ? MemoryImage(Uint8List.fromList((petData['petimg'] as Blob).toBytes()))
        : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pet Details'),
      ),
      body: Stack(
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
                  height: MediaQuery.of(context).size.height, //scroll function
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // fix the image alignment
                    children: [
                      if (petImage != null)
                        Image(image: petImage)
                      else
                        const Image(image: AssetImage('assets/placeholder.jpg')),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start, // text alignment
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
