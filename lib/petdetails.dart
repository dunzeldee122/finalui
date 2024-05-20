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
        title: Text(petData['name']),
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
              crossAxisAlignment: CrossAxisAlignment.start, // Align children to the left
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height, // Ensure the SingleChildScrollView takes full height
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center, // Center the image
                    children: [
                      if (petImage != null)
                        Image(image: petImage)
                      else
                        Image(image: AssetImage('assets/no_image_available.jpg')),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
                          children: [
                            Text(
                              'Name: ${petData['name']}',
                              style: TextStyle(fontSize: 22, fontWeight: FontWeight.normal),
                            ),
                            Text(
                              'Type: ${petData['type']}',
                              style: TextStyle(fontSize: 20),
                            ),
                            Text(
                              'Breed: ${petData['breed']}',
                              style: TextStyle(fontSize: 20),
                            ),
                            Text(
                              'Trait: ${petData['trait']}',
                              style: TextStyle(fontSize: 20),
                            ),
                            Text(
                              'Color: ${petData['color']}',
                              style: TextStyle(fontSize: 20),
                            ),
                            Text(
                              'Age: ${petData['age']}',
                              style: TextStyle(fontSize: 20),
                            ),
                            Text(
                              'Price: \$${petData['price']}',
                              style: TextStyle(fontSize: 20),
                            ),
                            SizedBox(height: 10),
                            FutureBuilder<String>(
                              future: fetchUserPhone(petData['uid']),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  final phone = snapshot.data ?? '';
                                  return Text(
                                    'Number: $phone',
                                    style: TextStyle(fontSize: 20),
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

  Future<String> fetchUserPhone(int userId) async {
    try {
      final conn = await getDatabaseConnection();
      final result = await conn.query('SELECT phone FROM user WHERE uid = ?', [userId]);
      if (result.isNotEmpty) {
        return result.first.fields['phone'] ?? '';
      } else {
        return '';
      }
    } catch (e) {
      print('Error fetching user phone: $e');
      return '';
    }
  }
}
