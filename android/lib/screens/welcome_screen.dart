import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:http/http.dart' as http;
import 'package:qr_reader_app/screens/reader.dart';
import 'package:qr_reader_app/screens/security_check.dart';
import 'dart:convert';
import 'product_grid_view.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';

  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<Color?> animation;
  bool showWelcomeScreen = true;

  // Sample product data
  List<Map<String, dynamic>> products = [];

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    animation = ColorTween(begin: Colors.blueGrey, end: Colors.white)
        .animate(controller);
    controller.forward();
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> fetchProducts() async {
    final response = await http.get(Uri.parse('https://chitkara-tzcs.onrender.com/api/getallproducts'));
    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body)['data'];
      setState(() {
        products = responseData.cast<Map<String, dynamic>>();
      });
    } else {
      throw Exception('Failed to load products');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: Column(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          showWelcomeScreen = true;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: showWelcomeScreen ? Colors.blue : Colors.grey,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Center(
                          child: Text(
                            'Welcome Screen',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        await fetchProducts();
                        setState(() {
                          showWelcomeScreen = false;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: showWelcomeScreen ? Colors.grey : Colors.blue,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Center(
                          child: Text(
                            'Other Screen',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (showWelcomeScreen)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Image.asset(
                          'images/logo.png',
                          height: 150.0,
                        ),
                        DefaultTextStyle(
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 45.0,
                            fontWeight: FontWeight.w900,
                          ),
                          child: AnimatedTextKit(
                            animatedTexts: [
                              TypewriterAnimatedText(
                                'Rapid Receipt',
                                speed: const Duration(milliseconds: 200),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 48.0,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (ctx) => ScanScreen(),
                        ));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlueAccent.shade400,
                        padding: const EdgeInsets.all(20),
                      ),
                      child: const Text('🛒 Start Shopping'),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (ctx) => SecurityCheckScreen(),
                        ));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent.shade200,
                        padding: const EdgeInsets.all(20),
                      ),
                      child: const Text('🔒 Receipt Verification'),
                    ),
                  ],
                ),
              ),
            ),
          if (!showWelcomeScreen && products.isNotEmpty)
            Expanded(
              child: ProductGridView(products: products),
            ),
        ],
      ),
    );
  }
}
