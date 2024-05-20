import 'package:flutter/material.dart';

class PetDetailsPage extends StatelessWidget {
  final Map<String, dynamic> petData;

  const PetDetailsPage({Key? key, required this.petData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(petData['name']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Type: ${petData['type']}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'Breed: ${petData['breed']}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'Trait: ${petData['trait']}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'Color: ${petData['color']}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'Age: ${petData['age']}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'Price: ${petData['price']}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            // Add more details as needed
          ],
        ),
      ),
    );
  }
}
