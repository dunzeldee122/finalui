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
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchPurchases();
  }

  Future<void> fetchPurchases() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final List<Map<String, dynamic>> result = await getPurchasesForUser(widget.userId);
      setState(() {
        purchases = result;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching purchases: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Purchased'),
      ),
      body: _isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : purchases.isNotEmpty
          ? RefreshIndicator(
        onRefresh: fetchPurchases,
        child: ListView.builder(
          itemCount: purchases.length,
          itemBuilder: (context, index) {
            final purchase = purchases[index];
            final petImageBytes = purchase['petimg'] as Blob?;
            final petImageWidget = petImageBytes != null
                ? Image.memory(
              Uint8List.fromList(petImageBytes.toBytes()),
              width: 50,
              height: 50,
            )
                : Container();
            return ListTile(
              leading: petImageWidget,
              title: Text('Item: ${purchase['name']}'),
              subtitle: Text('Price: \$${purchase['price']}'),
            );
          },
        ),
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
    final result = await conn.query('''
      SELECT p.*, pet.*
      FROM purchased p
      INNER JOIN petinfo pet ON p.pet_id = pet.pui
      WHERE p.user_id = ?
    ''', [userId]);

    List<Map<String, dynamic>> purchases = [];
    for (var row in result) {
      Map<String, dynamic> purchaseMap = {};
      row.fields.forEach((key, value) {
        if (value is Blob) {
          purchaseMap[key] = value;
        } else if (value is DateTime) {
          purchaseMap[key] = value.toString();
        } else {
          purchaseMap[key] = value;
        }
      });
      purchases.add(purchaseMap);
    }

    return purchases;
  } catch (e) {
    print('Error fetching purchases for user: $e');
    return [];
  }
}
