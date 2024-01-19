import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';

class CreateScreen extends StatefulWidget {
  @override
  _CreateScreenState createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  var qrstr = 'Add Data';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Creating QR code'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: BarcodeWidget(
              data: qrstr,
              barcode: Barcode.qrCode(),
              color: Colors.blue,
              height: 250,
              width: 250,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width * 0.8,
              child: TextField(
                onChanged: (val) {
                  setState(() {
                    qrstr = val;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Enter your data here',
                  labelText: 'Data for QR code',
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200], // Adjust the background color
                ),
              ),
            ),
          ),
          const SizedBox(height: 16), // Adjust the spacing
        ],
      ),
    );
  }
}
