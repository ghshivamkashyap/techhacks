import 'package:flutter/material.dart';

class ProductDetailsPage extends StatefulWidget {
  final String image;
  final String name;
  final int mrp;
  final int currPrice;
  final String pid;


  const ProductDetailsPage({
    Key? key,
    required this.image,
    required this.name,
    required this.mrp,
    required this.currPrice,
    required this.pid, //xx
  }) : super(key: key);

  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  double reviews = 3.0; // Initialize with a default value

  @override
  Widget build(BuildContext context) {
    // Calculate discount percentage
    double discountPercentage = ((widget.mrp - widget.currPrice) / widget.mrp) * 100;

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
                widget.image,
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
                    widget.pid,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: '₹${widget.mrp}',
                          style: TextStyle(
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                          children: [
                            TextSpan(
                              text: '  ₹${widget.currPrice}',
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                              ),
                            ),
                          ],
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

            // Reviews Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Reviews',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          // Update reviews to 1.0 when the first star is tapped
                          setState(() {
                            reviews = 1.0;
                          });
                        },
                        child: Icon(
                          Icons.star,
                          color: reviews >= 1.0 ? Colors.yellow : Colors.grey,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // Update reviews to 2.0 when the second star is tapped
                          setState(() {
                            reviews = 2.0;
                          });
                        },
                        child: Icon(
                          Icons.star,
                          color: reviews >= 2.0 ? Colors.yellow : Colors.grey,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // Update reviews to 3.0 when the third star is tapped
                          setState(() {
                            reviews = 3.0;
                          });
                        },
                        child: Icon(
                          Icons.star,
                          color: reviews >= 3.0 ? Colors.yellow : Colors.grey,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // Update reviews to 4.0 when the fourth star is tapped
                          setState(() {
                            reviews = 4.0;
                          });
                        },
                        child: Icon(
                          Icons.star,
                          color: reviews >= 4.0 ? Colors.yellow : Colors.grey,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // Update reviews to 5.0 when the fifth star is tapped
                          setState(() {
                            reviews = 5.0;
                          });
                        },
                        child: Icon(
                          Icons.star,
                          color: reviews >= 5.0 ? Colors.yellow : Colors.grey,
                        ),
                      ),
                      SizedBox(width: 8.0),
                      Text(
                        '$reviews',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Description Card with Title
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Card(
                    margin: EdgeInsets.all(16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    elevation: 2.0,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Experience a refreshing cleanse with our gentle face wash, formulated to remove impurities and leave your skin revitalized. Elevate your skincare routine with our luxurious face packs, crafted with natural ingredients to detoxify, brighten, and nourish, offering a spa-like experience for a radiant complexion.',
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

