import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../../models/home_model.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final int limit = 10;
  int skip = 0;
  int total = 0;
  List<Product> products = [];
  PageController pageController = PageController();
  String selectedThumbnail = ''; // Track the selected thumbnail URL

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      final response = await http.get(
          Uri.parse('https://dummyjson.com/products?limit=$limit&skip=$skip'));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<dynamic> productsJson = jsonData['products'];
        final List<Product> fetchedProducts = productsJson
            .map((productJson) => Product.fromJson(productJson))
            .toList();

        setState(() {
          products.addAll(fetchedProducts);
          total = jsonData['total'];
          skip += limit;
        });
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching products: $error');
    }
  }

  void goToNextPage() {
    if (pageController.page == products.length - 1) {
      fetchProducts();
    }
    pageController.nextPage(
        duration: Duration(milliseconds: 500), curve: Curves.ease);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void onPageChanged(int index) {
    setState(() {
      selectedThumbnail =
          ''; // Reset the selected thumbnail when changing pages
    });
  }

  void selectThumbnail(String thumbnail) {
    setState(() {
      selectedThumbnail = thumbnail;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: PageView.builder(
          controller: pageController,
          itemCount: products.length,
          onPageChanged: onPageChanged,
          itemBuilder: (context, index) {
            final product = products[index];
            final String currentThumbnail = selectedThumbnail.isNotEmpty
                ? selectedThumbnail
                : product.thumbnail;

            return Container(
              height: 400,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.tealAccent,
                    Color(0xFFB71C1C)
                  ], // Update with desired colors
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Card(
                semanticContainer: true,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                margin: const EdgeInsets.only(
                    top: 100, left: 10, right: 10, bottom: 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                color: Colors.white38,
                elevation: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, top: 10),
                      child: Image.network(
                        currentThumbnail,
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: MediaQuery.of(context).size.height * 0.24,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: product.images.map(
                        (image) {
                          return Expanded(
                            child: GestureDetector(
                              onTap: () {
                                selectThumbnail(image);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.network(
                                  image,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          );
                        },
                      ).toList(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, top: 20),
                      child: Text(product.brand),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0, top: 07),
                          child: Text(
                            product.category,
                            style: const TextStyle(color: Colors.white60),
                          ),
                        ),
                        Text.rich(TextSpan(children: [
                          TextSpan(
                              text: '${product.rating.toStringAsFixed(2)} ',
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600)),
                          const TextSpan(
                              text: ' ★★★★★',
                              style: TextStyle(
                                color: Colors.amber,
                              )),
                        ]))
                      ],
                    ),
                    const SizedBox(height: 20),
                    ListTile(
                      title: Text(
                        product.title,
                        style: const TextStyle(
                            fontWeight: FontWeight.w800, fontSize: 25),
                      ),
                      subtitle: Text(
                        product.description,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                      ),
                      trailing: Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                            fontWeight: FontWeight.w800, fontSize: 20),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          ' Discount :  ${product.discountPercentage.toStringAsFixed(2)} %',
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          '       Stock : ${product.stock.toString()}',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(width: 20),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        bottomNavigationBar: total > skip
            ? BottomAppBar(
                child: SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.teal,
                      onPrimary: Colors.white,
                      elevation: 60, // Elevation
                      shadowColor: Colors.amber,
                    ),
                    onPressed: goToNextPage,
                    child: const Text('Skip'),
                  ),
                ),
              )
            : const CircularProgressIndicator(),
      ),
    );
  }
}
