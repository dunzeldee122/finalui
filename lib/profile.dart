import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'dbconnection.dart';

class ProfilePage extends StatefulWidget {
  final int? userId;

  const ProfilePage({Key? key, this.userId, required Map userData}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  String? _firstNameError;
  String? _lastNameError;
  String? _phoneError;
  String? _emailError;
  String? _addressError;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    if (widget.userId == null) {

      return;
    }

    try {
      final conn = getDatabaseConnection();
      final result = await conn.query(
        'SELECT fname, lname, phone, email, address FROM user WHERE uid = ?',
        [widget.userId],
      );

      if (result.isNotEmpty) {
        final userData = result.first.fields;
        setState(() {
          _firstNameController.text = '${userData['fname']}';
          _lastNameController.text = '${userData['lname']}';
          _phoneController.text = userData['phone'] ?? '';
          _emailController.text = userData['email'] ?? '';
          _addressController.text = userData['address'] ?? '';
        });
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  bool _validateFields() {
    bool isValid = true;

    if (_firstNameController.text.isEmpty) {
      setState(() {
        _firstNameError = 'First name cannot be empty';
      });
      isValid = false;
    }

    if (_lastNameController.text.isEmpty) {
      setState(() {
        _lastNameError = 'Last name cannot be empty';
      });
      isValid = false;
    }

    if (_phoneController.text.isEmpty) {
      setState(() {
        _phoneError = 'Phone number cannot be empty';
      });
      isValid = false;
    } else if (_phoneController.text.length != 11) {
      setState(() {
        _phoneError = 'Enter a valid phone number';
      });
      isValid = false;
    }

    if (_emailController.text.isEmpty) {
      setState(() {
        _emailError = 'Email address cannot be empty';
      });
      isValid = false;
    } else if (!_emailController.text.endsWith('.com')) {
      setState(() {
        _emailError = 'Enter a valid email address';
      });
      isValid = false;
    }

    if (_addressController.text.isEmpty) {
      setState(() {
        _addressError = 'Address cannot be empty';
      });
      isValid = false;
    }

    return isValid;
  }

  Future<void> _updateUserData() async {
    if (!_validateFields()) {
      return;
    }

    try {
      final conn = getDatabaseConnection();
      await conn.query(
        'UPDATE user SET fname = ?, lname = ?, phone = ?, email = ?, address = ? WHERE uid = ?',
        [_firstNameController.text, _lastNameController.text, _phoneController.text, _emailController.text, _addressController.text, widget.userId],
      );

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Profile updated"),
            content: const Text("Your profile has been successfully updated."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    } catch (e) {
      print('Error updating user data: $e');
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final transparentColor = const Color.fromRGBO(166, 123, 91, 0.5);

    return Scaffold(
      body: Stack(
          children: [
      Container(
      decoration: const BoxDecoration(
      image: DecorationImage(
          image: AssetImage('assets/profilebg2.jpg'),
      fit: BoxFit.fill,
    ),
    ),
    ),
    SingleChildScrollView(
    child: Column(
    children: [
    SizedBox(height: MediaQuery.of(context).padding.top),
    const SizedBox(height: kToolbarHeight),
    Padding(
    padding: const EdgeInsets.all(16.0),
    child: TextField(
    controller: _firstNameController,
    decoration: InputDecoration(
    hintText: 'First Name',
    filled: true,
    fillColor: transparentColor,
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.0),
    borderSide: BorderSide.none,
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
    errorText: _firstNameError,
    ),
    ),
    ),
    Padding(
    padding: const EdgeInsets.all(16.0),
    child: TextField(
    controller: _lastNameController,
    decoration: InputDecoration(
    hintText: 'Last Name',
    filled: true,
    fillColor: transparentColor,
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.0),
    borderSide: BorderSide.none,
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
    errorText: _lastNameError,
    ),
    ),
    ),
    Padding(
    padding: const EdgeInsets.all(16.0),
    child: TextField(
    controller: _phoneController,
    keyboardType: TextInputType.phone,
    decoration: InputDecoration(
    hintText: 'Phone',
    filled: true,
    fillColor: transparentColor,
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.0),
    borderSide: BorderSide.none,
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
    errorText: _phoneError,
    ),
    ),
    ),
    Padding(
    padding: const EdgeInsets.all(16.0),
    child: TextField(
    controller: _emailController,
    decoration: InputDecoration(
    hintText: 'Email Address',
    filled: true,
    fillColor: transparentColor,
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.0),
    borderSide: BorderSide.none,
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
    errorText: _emailError,
    ),
    ),
    ),
    Padding(
    padding: const EdgeInsets.all(16.0),
    child: TextField(
    controller: _addressController,
    decoration: InputDecoration(
    hintText: 'Address',
    filled: true,
    fillColor: transparentColor,
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.0),
    borderSide: BorderSide.none,
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
    errorText: _addressError,
    ),
    ),
    ),
    ],
    ),
    ),
            Positioned(
              bottom: 16.0,
              right: 16.0,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _firstNameError = _firstNameController.text.isEmpty ? 'First name cannot be empty' : null;
                    _lastNameError = _lastNameController.text.isEmpty ? 'Last name cannot be empty' : null;
                    _phoneError = _phoneController.text.isEmpty || _phoneController.text.length != 11 ? 'Enter a valid phone number' : null;
                    _emailError = _emailController.text.isEmpty || !_emailController.text.endsWith('.com') ? 'Enter a valid email address' : null;
                    _addressError = _addressController.text.isEmpty ? 'Address cannot be empty' : null;
                  });
                  _updateUserData();
                },
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.edit,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).padding.top,
              left: 16.0,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ],
      ),
    );
  }
}
