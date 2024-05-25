import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:meowdoption/dbconnection.dart';

class PurchasedPage extends StatefulWidget {
  final int userId;

  const PurchasedPage({Key? key, required this.userId}) : super(key: key);

  @override
  _PurchasedPageState createState() => _PurchasedPageState();
}

class _PurchasedPageState extends State<PurchasedPage> {
  List<Map<String, dynamic>> purchases = [];

  @override
  void initState() {
    super.initState();
    fetchPurchases();
  }

  Future<void> fetchPurchases() async {
    try {
      final List<Map<String, dynamic>> result = await getPurchasesForUser(widget.userId);
      setState(() {
        purchases = result;
      });
    } catch (e) {
      print('Error fetching purchases: $e');
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Purchased'),
      ),
      body: purchases.isNotEmpty
          ? ListView.builder(
        itemCount: purchases.length,
        itemBuilder: (context, index) {
          final purchase = purchases[index];
          return ListTile(
            leading: Image.memory(
              Uint8List.fromList((purchase['petimg'] as Blob).toBytes()),
              width: 50, // Adjust the width as needed
              height: 50, // Adjust the height as needed
            ),
            title: Text('Item: ${purchase['name']}'), // Assuming the field name in petinfo table is 'name'
            subtitle: Text('Price: \$${purchase['price']}'),
          );
        },
      )
          : Center(
        child: Text('No purchases found.'),
      ),
    );
  }
}

Future<List<Map<String, dynamic>>> getPurchasesForUser(int? userId) async {
  if (userId == null) {
    return [];
  }

  try {
    final conn = await getDatabaseConnection();
    final result = await conn.query('SELECT * FROM petinfo WHERE uid = ?', [userId]);

    List<Map<String, dynamic>> purchases = [];
    for (var row in result) {
      // Convert each row into a map
      Map<String, dynamic> purchaseMap = {};
      row.fields.forEach((key, value) {
        if (key == 'petimg' && value is Blob) {
          // Directly store the Blob
          purchaseMap[key] = value;
        } else {
          purchaseMap[key] = value;
        }
      });
      purchases.add(purchaseMap);
    }

    return purchases;
  } catch (e) {
    print('Error fetching purchases for user: $e');
    return []; // Return an empty list in case of error
  }
}
