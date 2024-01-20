import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
    required this.pid,
  }) : super(key: key);

  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

var Data = [];

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  double reviews = 3.0;
  List<Map<String, dynamic>> prices = [];

  @override
  void initState() {
    super.initState();
    fetchPrices(widget.pid);
  }

  Future<void> fetchPrices(String pid) async {
    final response = await http.get(Uri.parse(
        'https://chitkara-tzcs.onrender.com/api/getsameproducts/$pid'));

    if (response.statusCode == 200) {
      Data = json.decode(response.body)['data'];
      // final pricesData = Data['data'];
      print('$Data');

      setState(() {
        // prices = pricesData;
      });
    } else {
      print('Failed to fetch prices: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    double discountPercentage =
        ((widget.mrp - widget.currPrice) / widget.mrp) * 100;

    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.5,
              child: Image.network(
                widget.image,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.name,
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
                                decoration: TextDecoration.none,
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

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Available at',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Container(
                        height: 150.0,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: Data.length,
                          itemBuilder: (context, index) {
                            var product = Data[index];
                            return PriceCardTile(
                              logo: product['address']['logo'],
                              storeName: product['address']['name'],
                              storeAddress: product['address']['address'],
                              currPrice: product['currprice'],
                            );
                          },
                        ),
                      ),
                    ],
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


class PriceCardTile extends StatelessWidget {
  final String logo;
  final String storeName;
  final String storeAddress;
  final int currPrice;

  const PriceCardTile({
    Key? key,
    required this.logo,
    required this.storeName,
    required this.storeAddress,
    required this.currPrice,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200.0,
      height: 500.0,
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      child: Card(
        elevation: 2.0,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(logo),
                radius: 22.0,
              ),
              Text(
                storeName,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                storeAddress,
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 5.0),
              Row(
                children: [
                  Text(
                    '₹$currPrice',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}


