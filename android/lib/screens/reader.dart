import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:barcode_widget/barcode_widget.dart';


void main() {
  runApp(MaterialApp(
    home: ScanScreen(),
  ));
}

class ScanScreen extends StatefulWidget {
  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  List<String> cartItems = [];
  Map<String, dynamic> productMap = {};
  List<String> productKeys = [];
  String qrCodeData = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rapid Receipts'),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  // Navigate to the shopping cart or show cart contents
                },
              ),
              if (cartItems.isNotEmpty)
                Positioned(
                  top: 0,
                  right: 0,
                  child: CircleAvatar(
                    backgroundColor: Colors.black,
                    radius: 10,
                    child: Text(
                      cartItems.length.toString(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: productKeys.length,
        itemBuilder: (context, index) {
          final productId = productKeys[index];
          final productData = productMap[productId];
          final productName = productData['name'];
          final productPrice = productData['price'];
          final productQuantity = productData['quantity'] ?? 1; // Default to 1 if not set

          return Card(
            margin: const EdgeInsets.all(8),
            elevation: 4,
            child: ListTile(
              title: Text('Product: $productName x$productQuantity'),
              subtitle: Text('Total Price: \$${(productPrice * productQuantity).toStringAsFixed(2)}'),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton(
                  onPressed: scanQr,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2ECC71),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  child: const Text('Add Items', style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
            if (cartItems.isNotEmpty)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: ElevatedButton(
                    onPressed: checkout,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF6049),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    child: const Text('Checkout', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> scanQr() async {
    try {
      FlutterBarcodeScanner.scanBarcode(
        '#2A99CF',
        'Cancel',
        true,
        ScanMode.QR,
      ).then((value) {
        if (value.isNotEmpty) {
          getProductById(value);
        }
      });
    } catch (e) {
      // Handle QR scan error
    }
  }

  // Modify the checkout function
  void checkout() async {
    final apiUrl = 'https://chitkara-tzcs.onrender.com/api/getbill';

    try {
      print('Starting checkout...');
      print('All Pids: $allPids');

      final requestData = {
        'items': allPids,
        // Add other necessary details here
      };

      final requestBody = json.encode(requestData);

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: requestBody,
      ).timeout(const Duration(seconds: 600));

      print('API Response: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final billId = responseData['bill'];
        final products = billId['products'];
        final totalPrice = billId['totalPrice'];
        final mrp = billId['mrp'];
        final id = billId['_id'];
        print(id);

        // Display the response data on the screen
        showBillDialog(context, products, totalPrice, mrp, id);

        setState(() {
          qrCodeData = billId['_id'];
          productMap.clear(); // Clear the product map after successful checkout
          productKeys.clear(); // Clear product keys
          cartItems.clear(); // Clear cart items
          allPids.clear();
        });

        // Show a success dialog or navigate to a success screen
        // showSuccessDialog(context, 'Checkout Successful!');
      } else {
        // Show an error dialog or handle the error appropriately
        showErrorDialog(context, 'Failed to create a bill. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Show an error dialog or handle the error appropriately
      showErrorDialog(context, 'Error: $e');
    }
  }

  void showBillDialog(BuildContext context, List<dynamic> products, dynamic totalPrice, dynamic mrp, String qrCodeData) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Bill Details',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Divider(color: Colors.grey),
                SizedBox(height: 8),
                Text('Products:', style: TextStyle(fontWeight: FontWeight.bold)),
                for (var product in products) Text('- $product'),
                SizedBox(height: 16),
                Text('Total Price Rs: ${totalPrice.toDouble().toStringAsFixed(2)}', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('MRP Rs: ${mrp.toDouble().toStringAsFixed(2)}', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 16),
                // Display the QR code
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: BarcodeWidget(
                    data: qrCodeData, // Use the QR code data here
                    barcode: Barcode.qrCode(),
                    color: Colors.blue,
                    height: 150, // Adjust the size as needed
                    width: 150,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }



  // end here


  List<String> allPids = [];
  Future<void> getProductById(String productId) async {
    final apiUrl = 'https://chitkara-tzcs.onrender.com/api/getproductbyid/$productId';

    try {
      print("$productId");
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (!jsonData['iserror']) {
          final productData = jsonData['product'];
          final productName = productData['name'];
          final productCurrentPrice = productData['currprice'];
          // final pid = productData['pid'];
          final pid = productData['pid'].toString();
          // Add the product details to your app state
          final id = productData['_id'];
          productMap[id] = {
            'name': productName,
            'price': productCurrentPrice,
          };
          productKeys.add(id);

          // Add the pid to the global list
          allPids.add(pid);

          // Optionally, you can update the cartItems list
          setState(() {
            cartItems.add(productName); // Assuming you want to add the product name to cartItems
          });
        } else {
          // Show an error dialog or handle the error appropriately
          showErrorDialog(context, 'Error: ${jsonData['message']}');
        }
      } else {
        // Show an error dialog or handle the error appropriately
        showErrorDialog(context, "Failed to get product by ID. Status code: ${response.statusCode}");
      }
    } catch (e) {
      // Show an error dialog or handle the error appropriately
      showErrorDialog(context, "Error: $e");
    }
  }
  // chat gpt code end
  double calculateTotalPrice() {
    double totalPrice = 0.0;
    for (final productId in productKeys) {
      totalPrice += productMap[productId]['price'];
    }
    return totalPrice;
  }

  void showSuccessDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

}
