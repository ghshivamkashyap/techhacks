import 'package:flutter/material.dart';

class ProductDetailsPage extends StatelessWidget {
  final String image;
  final String name;
  final int mrp;
  final int currPrice;

  const ProductDetailsPage({
    Key? key,
    required this.image,
    required this.name,
    required this.mrp,
    required this.currPrice,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calculate discount percentage
    double discountPercentage = ((mrp - currPrice) / mrp) * 100;

    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Product Image
            Container(
              height: MediaQuery.of(context).size.height * 0.5,
              child: Image.network(
                image,
                fit: BoxFit.cover,
              ),
            ),

            // Price Information
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '₹$mrp',
                        style: TextStyle(
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      Text(
                        '₹$currPrice',
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    '${discountPercentage.toStringAsFixed(2)}% OFF',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Description (Replace this with actual product description)
            Card(
              margin: EdgeInsets.all(16.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              elevation: 2.0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Product description will be fetched from the backend.',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Handle Buy Now
                    // Add your logic here
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    padding: EdgeInsets.all(16.0),
                  ),
                  child: Text(
                    'Buy Now',
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
              ),
              SizedBox(width: 16.0),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Handle Add to Cart
                    // Add your logic here
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    padding: EdgeInsets.all(16.0),
                  ),
                  child: Text(
                    'Add to Cart',
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
