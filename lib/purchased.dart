import 'package:flutter/material.dart';

class PurchasedPage extends StatelessWidget {
  final Map<String, dynamic> userData;

  const PurchasedPage({Key? key, required this.userData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Purchased'),
      ),
      body: Center(
        child: Text('This is the Purchased Page'),
      ),
    );
  }
}
