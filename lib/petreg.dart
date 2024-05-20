import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meowdoption/dbconnection.dart';

class PetRegistrationPage extends StatefulWidget {
  final Map<String, dynamic> userData;

  const PetRegistrationPage({Key? key, required this.userData}) : super(key: key);

  @override
  _PetRegistrationPageState createState() => _PetRegistrationPageState();
}

class _PetRegistrationPageState extends State<PetRegistrationPage> {
  File? _imageFile;

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      }
    });
  }

  Future<void> _registerPet(BuildContext context) async {
    if (_imageFile != null) {
      final Uint8List imageData = await _imageFile!.readAsBytes();

      try {
        final uid = widget.userData['uid']; // Use the actual user's UID

        await registerPet(
          userId: uid,
          name: _nameController.text,
          type: _typeController.text,
          breed: _breedController.text,
          trait: _traitController.text,
          color: _colorController.text,
          age: int.parse(_ageController.text),
          price: int.parse(_priceController.text),
          petImage: imageData,
        );

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Pet Listed for Adoption'),
              content: const Text('Your pet has been listed for adoption.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pop(context);
                  },
                  child: const Text('Close'),
                ),
              ],
            );
          },
        );
      } catch (e) {
        print('Error registering pet: $e');
      }
    }
  }

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _breedController = TextEditingController();
  final TextEditingController _traitController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _typeController.dispose();
    _breedController.dispose();
    _traitController.dispose();
    _colorController.dispose();
    _ageController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Pet Registration'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/profilebg.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 120.0, 20.0, 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: _nameController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        filled: true,
                        fillColor: Color(0xFFa67b5b),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _typeController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Type',
                        filled: true,
                        fillColor: Color(0xFFa67b5b),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _breedController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Breed',
                        filled: true,
                        fillColor: Color(0xFFa67b5b),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _traitController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Trait',
                        filled: true,
                        fillColor: Color(0xFFa67b5b),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _colorController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Color',
                        filled: true,
                        fillColor: Color(0xFFa67b5b),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _ageController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Age',
                        filled: true,
                        fillColor: Color(0xFFa67b5b),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _priceController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Price',
                        filled: true,
                        fillColor: Color(0xFFa67b5b),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Select Image'),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: [
                                    GestureDetector(
                                      child: const Text(
                                        'Take a picture',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      onTap: () {
                                        _pickImage(ImageSource.camera);
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    const SizedBox(height: 20),
                                    GestureDetector(
                                      child: const Text(
                                        'Choose from gallery',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      onTap: () {
                                        _pickImage(ImageSource.gallery);
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFa67b5b),
                      ),
                      child: const Text('Select an Image', style: TextStyle(color: Colors.white)),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        _registerPet(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFa67b5b),
                      ),
                      child: const Text('Register', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
