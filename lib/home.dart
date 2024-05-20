import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mysql1/mysql1.dart';
import 'package:meowdoption/dbconnection.dart';
import 'package:meowdoption/petlist.dart';
import 'login.dart';
import 'petreg.dart';
import 'profile.dart';

class HomePage extends StatefulWidget {
  final Map<String, dynamic> userData;

  const HomePage({Key? key, required this.userData}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? _selectedImage;
  final String _defaultAvatar = 'assets/ava.jpg';
  String _searchQuery = '';

  Future<void> _getImageFromGallery() async {
    final pickedFile = await ImagePicker.platform.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });

      // Convert image to bytes
      Uint8List imageBytes = await _selectedImage!.readAsBytes();

      // Update the user image in the database
      await _updateUserImage(widget.userData['uid'], imageBytes);
    }
  }

  Future<void> _updateUserImage(int userId, Uint8List imageBytes) async {
    try {
      final conn = await getDatabaseConnection();
      await conn.query('UPDATE user SET userimg = ? WHERE uid = ?', [imageBytes, userId]);
    } catch (e) {
      print('Error updating user image: $e');
    }
  }

  Future<List<Map<String, dynamic>>> fetchAllPets() async {
    try {
      final conn = await getDatabaseConnection();
      final results = await conn.query('SELECT * FROM petinfo');
      return results.map((row) => row.fields).toList();
    } catch (e) {
      print('Error fetching pet list: $e');
      return [];
    }
  }

  Future<MemoryImage?> getPetImage(int petId) async {
    try {
      final conn = await getDatabaseConnection();
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

  Future<void> _showLogoutConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to log out?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                // Navigate back to the login screen
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _refreshHomePage() async {
    setState(() {}); // Refresh the state
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              final String? query = await showSearch(
                context: context,
                delegate: PetSearchDelegate(),
              );
              if (query != null && query.isNotEmpty) {
                setState(() {
                  _searchQuery = query;
                });
              }
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/pawbg.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(20.0),
                color: const Color(0xFFa67b5b),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircleAvatar(
                      radius: 50.0,
                      backgroundImage: _selectedImage != null
                          ? FileImage(_selectedImage!)
                          : AssetImage(_defaultAvatar) as ImageProvider<Object>?,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: _getImageFromGallery,
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                title: Text(
                  'Name: ${widget.userData['fname']} ${widget.userData['lname']}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              ListTile(
                title: Text(
                  'Phone: ${widget.userData['phone']}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              ListTile(
                title: Text(
                  'Email: ${widget.userData['email']}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              ListTile(
                title: Text(
                  'Address: ${widget.userData['address']}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              const Spacer(),
              ListTile(
                title: const Text(
                  'Pet Listed',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                leading: const Icon(Icons.pets),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PetList(user: widget.userData['uid'].toString())),
                  );
                },
              ),
              ListTile(
                title: const Text(
                  'Profile',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                leading: const Icon(Icons.person),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfilePage()),
                  );
                },
              ),
              ListTile(
                title: const Text(
                  'Logout',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                leading: const Icon(Icons.power_settings_new),
                onTap: () {
                  _showLogoutConfirmationDialog(context);
                },
              ),
            ],
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshHomePage,
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _searchQuery.isNotEmpty
              ? fetchFilteredPets(_searchQuery)
              : fetchAllPets(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              final pets = snapshot.data ?? [];
              return ListView.builder(
                itemCount: pets.length,
                itemBuilder: (context, index) {
                  final petData = pets[index];
                  return FutureBuilder<MemoryImage?>(
                    future: getPetImage(petData['pui']),
                    builder: (context, imageSnapshot) {
                      if (imageSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (imageSnapshot.hasError) {
                        return Text('Error: ${imageSnapshot.error}');
                      } else if (imageSnapshot.hasData &&
                          imageSnapshot.data != null) {
                        return ListTile(
                          title: Text('${petData['name']}'),
                          subtitle: Text('Type: ${petData['type']}\nBreed: ${petData['breed']}'),
                          leading: CircleAvatar(
                            backgroundImage: imageSnapshot.data,
                          ),
                        );
                      } else {
                        return ListTile(
                          title: Text('${petData['name']}'),
                          subtitle: Text('Type: ${petData['type']}\nBreed: ${petData['breed']}'),
                          leading: const CircleAvatar(),
                        );
                      }
                    },
                  );
                },
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  PetRegistrationPage(userData: widget.userData),
            ),
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: const Color(0xFFa67b5b),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}

class PetSearchDelegate extends SearchDelegate<String> {
  @override
  String get searchFieldLabel => 'Search by Type or Breed';

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchFilteredPets(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final pets = snapshot.data ?? [];
          if (pets.isEmpty) {
            return Center(
              child: Text('No pets found for the search query.'),
            );
          }
          return ListView.builder(
            itemCount: pets.length,
            itemBuilder: (context, index) {
              final petData = pets[index];
              return ListTile(
                title: Text('${petData['name']}'),
                subtitle: Text('Type: ${petData['type']}\nBreed: ${petData['breed']}'),
                leading: const CircleAvatar(), // You can add pet images here if needed
              );
            },
          );
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
