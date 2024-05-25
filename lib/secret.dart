import 'package:flutter/material.dart';
import 'admin.dart';

class SecretPage extends StatefulWidget {
  @override
  _SecretPageState createState() => _SecretPageState();
}

class _SecretPageState extends State<SecretPage> {
  String _input = "";

  void _handleKeyPress(String value) {
    setState(() {
      _input += value;
      if (_input.length == 4) {
        if (_input == "0000") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AdminPage()),
          );
        } else {
          _input = "";
        }
      }
    });
  }

  void _handleDelete() {
    setState(() {
      if (_input.isNotEmpty) {
        _input = _input.substring(0, _input.length - 1);
      }
    });
  }

  Widget _buildKeypadButton(String value) {
    return ElevatedButton(
      onPressed: () => _handleKeyPress(value),
      child: Text(value, style: TextStyle(fontSize: 24)),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(20),
        shape: CircleBorder(),
      ),
    );
  }

  Widget _buildDeleteButton() {
    return ElevatedButton(
      onPressed: _handleDelete,
      child: Icon(Icons.backspace, size: 24),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(20),
        shape: CircleBorder(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // behind AppBar so i can see the full bg
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,

      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Enter Code', style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            Text(_input, style: TextStyle(fontSize: 32, letterSpacing: 8)),
            SizedBox(height: 20),
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              children: [
                _buildKeypadButton("1"),
                _buildKeypadButton("2"),
                _buildKeypadButton("3"),
                _buildKeypadButton("4"),
                _buildKeypadButton("5"),
                _buildKeypadButton("6"),
                _buildKeypadButton("7"),
                _buildKeypadButton("8"),
                _buildKeypadButton("9"),
                _buildDeleteButton(),
                _buildKeypadButton("0"),
                SizedBox.shrink(), // Empty space
              ],
            ),
          ],
        ),
      ),
    );
  }
}
