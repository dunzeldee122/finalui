import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:meowdoption/dbconnection.dart';

class PetList extends StatefulWidget {
  final String user;

  // Constructor to receive the user name
  PetList({required this.user});

  @override
  _PetListState createState() => _PetListState();
}

class _PetListState extends State<PetList> {
  List<Map<String, dynamic>> pets = [];

  @override
  void initState() {
    super.initState();
    fetchPetList();
  }

  Future<void> fetchPetList() async {
    try {
      final conn = getDatabaseConnection();
      final results = await conn.query('SELECT * FROM petinfo WHERE uid = ?', [widget.user]);

      setState(() {
        pets = results.map((row) => row.fields).toList();
      });
    } catch (e) {
      print('Error fetching pet list: $e');
    }
  }

  Future<MemoryImage?> getPetImage(int petId) async {
    try {
      final conn = getDatabaseConnection();
      final result = await conn.query('SELECT petimg FROM petinfo WHERE pui = ?', [petId]);

      if (result.isNotEmpty) {
        final petImageBlob = result.first.fields['petimg'] as Blob?;
        if (petImageBlob != null) {
          final petImageData = petImageBlob.toBytes();
          return MemoryImage(Uint8List.fromList(petImageData));
        }
      }
    } catch (e) {
      print('Error fetching pet image: $e');
    }
    return null;
  }

  Future<void> deletePet(int petId) async {
    try {
      final conn = getDatabaseConnection();
      await conn.query('DELETE FROM petinfo WHERE pui = ?', [petId]);
      fetchPetList(); // Refresh the pet list after deletion
    } catch (e) {
      print('Error deleting pet: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pet Listed of ${widget.user}'),
      ),
      body: ListView.builder(
        itemCount: pets.length,
        itemBuilder: (context, index) {
          final petData = pets[index];
          return FutureBuilder<MemoryImage?>(
            future: getPetImage(petData['pui']),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.hasData && snapshot.data != null) {
                return ListTile(
                  title: Text('${petData['name']}'),
                  subtitle: Text('Type: ${petData['type']}\nBreed: ${petData['breed']}'),
                  leading: CircleAvatar(
                    backgroundImage: snapshot.data,
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      deletePet(petData['pui']); // Call delete function
                    },
                  ),
                );
              } else {
                return Text('No Image');
              }
            },
          );
        },
      ),
    );
  }
}


