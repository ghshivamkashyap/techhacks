import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SecurityCheckPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SecurityCheckScreen();
  }
}

class SecurityCheckScreen extends StatefulWidget {
  @override
  _SecurityCheckScreenState createState() => _SecurityCheckScreenState();
}

class _SecurityCheckScreenState extends State<SecurityCheckScreen> {
  String scannedData = '';
  List<ProductInfo> products = [];
  double totalPrice = 0.0;
  bool isLoading = false;

  final pastelPurple = const Color(0xFFB19CD9);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Security Check'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: isLoading ? null : scanQr,
                style: ElevatedButton.styleFrom(
                  backgroundColor: pastelPurple,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.qr_code, size: 30, color: Colors.white),
                    SizedBox(width: 10),
                    Text('Scan QR Code', style: TextStyle(fontSize: 20)),
                  ],
                ),
              ),
              SizedBox(height: 20),
              if (isLoading)
                CircularProgressIndicator()
              else if (products.isNotEmpty)
                Card(
                  elevation: 5,
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      Text(
                        'Product List:',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Divider(),
                      for (var product in products)
                        ListTile(
                          title: Text(
                            'Product: ${product.name}',
                            style: TextStyle(fontSize: 18),
                          ),
                          subtitle: Text(
                            'Price: \$${product.price.toStringAsFixed(2)}',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      Divider(),
                      Text(
                        'Total Price: \$${totalPrice.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> scanQr() async {
    try {
      final scannedValue = await FlutterBarcodeScanner.scanBarcode(
        '#2A99CF',
        'Cancel',
        true,
        ScanMode.QR,
      );

      if (scannedValue.isNotEmpty) {
        setState(() {
          scannedData = scannedValue;
          products.clear();
          totalPrice = 0.0;
          isLoading = true;
        });

        // Fetch and display product information
        await fetchApiData(scannedValue);

        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      // Handle QR scan error
    }
  }

  Future<void> fetchApiData(String scannedValue) async {
    final apiUrl = 'https://chitkara-tzcs.onrender.com/api/security/$scannedValue';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData['iserror'] == false) {
          final billData = jsonData['data'];

          if (billData.containsKey('products')) {
            final productsData = billData['products'];
            final mrp = billData['mrp']; // Assume 'mrp' is a single value

            for (var i = 0; i < productsData.length; i++) {
              final product = ProductInfo(
                name: productsData[i],
                price: mrp.toDouble(), // Use the single value of 'mrp'
              );
              products.add(product);
            }

            totalPrice = billData['totalPrice'].toDouble();
          } else {
            print('Error: Key "products" not found in the response');
          }
        } else {
          print('API Error: ${jsonData['message']}');
        }
      } else {
        print('Failed to fetch data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }
}

class ProductInfo {
  final String name;
  final double price;

  ProductInfo({
    required this.name,
    required this.price,
  });
}
