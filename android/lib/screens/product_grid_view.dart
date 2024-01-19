import 'package:flutter/material.dart';
import 'product_details_page.dart';

class ProductGridView extends StatelessWidget {
  final List<Map<String, dynamic>> products;

  const ProductGridView({Key? key, required this.products}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Preprocess the products list to keep only one product per unique name with the lowest price
    List<Map<String, dynamic>> uniqueProducts = [];

    for (var product in products) {
      var existingProduct = uniqueProducts.firstWhere(
            (element) => element['name'] == product['name'],
        orElse: () => {},
      );

      if (existingProduct.isEmpty || existingProduct['currprice'] > product['currprice']) {
        uniqueProducts.remove(existingProduct);
        uniqueProducts.add(product);
      }
    }

    return Container(
      padding: EdgeInsets.all(8.0),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: uniqueProducts.length,
        itemBuilder: (context, index) {
          final product = uniqueProducts[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailsPage(
                    image: product['image'],
                    name: product['name'],
                    mrp: product['mrp'],
                    currPrice: product['currprice'],
                  ),
                ),
              );
            },
            child: ProductTile(
              image: product['image'],
              name: product['name'],
              mrp: product['mrp'],
              currPrice: product['currprice'],
            ),
          );
        },
      ),
    );
  }
}

class ProductTile extends StatelessWidget {
  final String image;
  final String name;
  final int mrp;
  final int currPrice;

  const ProductTile({
    Key? key,
    required this.image,
    required this.name,
    required this.mrp,
    required this.currPrice,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 120.0,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8.0),
                topRight: Radius.circular(8.0),
              ),
              child: Center(
                child: Image.network(
                  image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(height: 4.0),
                Row(
                  children: [
                    Text(
                      '₹$mrp',
                      style: TextStyle(
                        color: Colors.grey,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    SizedBox(width: 8.0),
                    Text(
                      '₹$currPrice',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
