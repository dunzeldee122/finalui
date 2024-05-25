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
import 'petdetails.dart' as details;
import 'purchased.dart';

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
  MemoryImage? _userImage;

  @override
  void initState() {
    super.initState();
    _fetchUserImage(widget.userData['uid']);
  }

  Future<void> _fetchUserImage(int userId) async {
    try {
      final conn = await getDatabaseConnection();
      final result = await conn.query('SELECT userimg FROM user WHERE uid = ?', [userId]);

      if (result.isNotEmpty) {
        final userImageBlob = result.first.fields['userimg'] as Blob?;
        if (userImageBlob != null) {
          final userImageData = userImageBlob.toBytes();
          setState(() {
            _userImage = MemoryImage(Uint8List.fromList(userImageData));
          });
        }
      }
    } catch (e) {
      print('Error fetching user image: $e');
    }
  }

  Future<void> _getImageFromGallery() async {
    final pickedFile = await ImagePicker.platform.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });

      Uint8List imageBytes = await _selectedImage!.readAsBytes();
      await _updateUserImage(widget.userData['uid'], imageBytes);
      // Update the user image immediately after uploading
      setState(() {
        _userImage = MemoryImage(imageBytes);
      });
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

  Future<List<Map<String, dynamic>>> fetchFilteredPets(String query) async {
    try {
      final conn = await getDatabaseConnection();
      final results = await conn.query('SELECT * FROM petinfo WHERE type LIKE ? OR breed LIKE ?', ['%$query%', '%$query%']);
      return results.map((row) => row.fields).toList();
    } catch (e) {
      print('Error fetching filtered pet list: $e');
      return [];
    }
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
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
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
    setState(() {});
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
    delegate: PetSearchDelegate(this),
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
    drawer:Drawer(
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
                    backgroundImage: _userImage ?? AssetImage(_defaultAvatar) as ImageProvider<Object>?,
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
                'Purchases',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              leading: const Icon(Icons.shopping_cart),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PurchasedPage(userData: widget.userData),
                  ),
                );
              },
            ),
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
              onTap: () async {
                final updatedUserData = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(userId: widget.userData['uid'], userData: widget.userData),
                  ),
                );

                if (updatedUserData != null) {
                  setState(() {
                    widget.userData.addAll(updatedUserData);
                  });
                }
              },
            ),

            ListTile(
              title: const Text(
                'Logout',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              leading: const Icon(Icons.logout),
              onTap: () {
                _showLogoutConfirmationDialog(context);
              },
            ),
          ],
        ),
      ),
    )
      ,
      body: RefreshIndicator(
        onRefresh: _refreshHomePage,
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: fetchAllPets(),
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
                      if (imageSnapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (imageSnapshot.hasError) {
                        return Text('Error: ${imageSnapshot.error}');
                      } else if (imageSnapshot.hasData && imageSnapshot.data != null) {
                        return ListTile(
                          title: Text('${petData['name']}'),
                          subtitle: Text('Type: ${petData['type']}\nBreed: ${petData['breed']}'),
                          leading: CircleAvatar(
                            backgroundImage: imageSnapshot.data,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => details.PetDetailsPage(petData: petData),
                              ),
                            );
                          },
                        );
                      } else {
                        return ListTile(
                          title: Text('${petData['name']}'),
                          subtitle: Text('Type: ${petData['type']}\nBreed: ${petData['breed']}'),
                          leading: const CircleAvatar(), // Placeholder avatar
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => details.PetDetailsPage(petData: petData),
                              ),
                            );
                          },
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
              builder: (context) => PetRegistrationPage(userData: widget.userData),
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
  final _HomePageState homePageState;

  PetSearchDelegate(this.homePageState);

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
      future: homePageState.fetchFilteredPets(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final pets = snapshot.data ?? [];
          if (pets.isEmpty) {
            return const Center(
              child: Text('No pets found for the search query.'),
            );
          }
          return ListView.builder(
            itemCount: pets.length,
            itemBuilder: (context, index) {
              final petData = pets[index];
              return ListTile(
                title: Text('${petData['name']}'),
                subtitle: Text('Type: ${petData['type']}'),
                leading: FutureBuilder<MemoryImage?>(
                  future: homePageState.getPetImage(petData['pui']),
                  builder: (context, imageSnapshot) {
                    if (imageSnapshot.connectionState == ConnectionState.waiting) {
                      return const CircleAvatar(); // Placeholder avatar
                    } else if (imageSnapshot.hasError || imageSnapshot.data == null) {
                      return const CircleAvatar(); // Placeholder avatar
                    } else {
                      return CircleAvatar(
                        backgroundImage: imageSnapshot.data,
                      );
                    }
                  },
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => details.PetDetailsPage(petData: petData),
                    ),
                  );
                },
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
