import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ibeuty/apiservice.dart';
import 'package:ibeuty/cart1.dart';
import 'package:ibeuty/home.dart';
import 'package:ibeuty/login.dart';
import 'package:ibeuty/models/productmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductDetailScreen extends StatefulWidget {
  final List<Product> products;
  final int selectedProductIndex;

  const ProductDetailScreen({
    Key? key,
    required this.products,
    required this.selectedProductIndex,
  }) : super(key: key);

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int quantity = 1;
  ApiService apiService = ApiService();
  bool isLoggedIn = false;
  bool isLoading = false;
  bool showAllProducts = false;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    await apiService.fetchTodaydealProducts(context);
    setState(() {});
  }

  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    });
  }

  Future<void> _addToCart(BuildContext context) async {
    try {
      setState(() {
        isLoading = true;
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
      if (!isLoggedIn) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Login(initialPage: 'home')),
        );
        return;
      }

      Product selectedProduct = widget.products[widget.selectedProductIndex];

      String userId = prefs.getString('userId') ?? '';
      String accessToken = prefs.getString('accessToken') ?? '';

      Product productToAdd = Product(
        id: selectedProduct.id,
        name: selectedProduct.name,
        thumbnailImage: selectedProduct.thumbnailImage,
        hasDiscount: selectedProduct.hasDiscount,
        discount: selectedProduct.discount,
        strokedPrice: selectedProduct.strokedPrice,
        mainPrice: selectedProduct.mainPrice,
        rating: selectedProduct.rating,
        sales: selectedProduct.sales,
        quantity: quantity,
      );

      final apiUrl = 'http://okaymart.in/api/v2/carts/add';
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };
      final requestBody = {
        'id': productToAdd.id,
        'variant': 'None',
        'user_id': userId,
        'quantity': productToAdd.quantity,
      };

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Expanded(
                  child: Text('Added to Cart'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CartPage(),
                      ),
                    );
                  },
                  child: Text(
                    'Go to Cart',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            backgroundColor: Color.fromARGB(255, 17, 61, 97),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        final responseBody = jsonDecode(response.body);
        String errorMessage =
            responseBody['message'] ?? 'Failed to add to Cart';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (error) {
      print('Error during addToCart: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add to Cart. Please try again.'),
          duration: Duration(seconds: 2),
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Product product = widget.products[widget.selectedProductIndex];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Product',
            style: TextStyle(color: const Color.fromARGB(255, 5, 51, 88))),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          ListView(
            padding: EdgeInsets.all(16.0),
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 250,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(product.thumbnailImage),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Row(
                children: [
                  Flexible(
                    child: Text(
                      product.name,
                      textAlign: TextAlign.left,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(width: 100),
                ],
              ),
              SizedBox(height: 30),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '  Price: ',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: '${product.mainPrice}',
                      style: TextStyle(
                        color: const Color.fromARGB(255, 10, 74, 126),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("  Quantity:  "),
                  Container(
                    margin: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Container(
                      width: 140,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () {
                              updateQuantity(-1);
                            },
                          ),
                          Text(
                            '$quantity',
                            style: TextStyle(
                                color: Color.fromARGB(255, 6, 67, 117)),
                          ),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              updateQuantity(1);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40.0),
              Text(
                'Description: Product description goes here',
                style: TextStyle(fontSize: 15.0),
                maxLines: showAllProducts ? null : 2,
                overflow: showAllProducts
                    ? TextOverflow.visible
                    : TextOverflow.ellipsis,
              ),
              SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      showAllProducts = !showAllProducts;
                    });
                  },
                  child: Text(
                    showAllProducts ? 'View Less' : 'View More',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Products you may like',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children:
                      apiService.todaydealProducts.map((todaydealProducts) {
                    return SizedBox(
                      width: 150,
                      child: ProductCard(
                          product: todaydealProducts,
                          products: apiService.todaydealProducts),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          isLoading
              ? Positioned.fill(
                  child: Container(
                    color: Colors.black.withOpacity(0.5),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Color.fromARGB(255, 17, 61, 97),
                      ),
                    ),
                  ),
                )
              : SizedBox.shrink(),
        ],
      ),
      bottomNavigationBar: Container(
        height: 60,
        color: Color.fromARGB(255, 188, 214, 235),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: InkWell(
                  onTap: isLoading ? null : () => _addToCart(context),
                  child: Container(
                    height: 45,
                    child: Center(
                      child: Text(
                        'Add to Cart',
                        style: TextStyle(color: Colors.white, fontSize: 17),
                      ),
                    ),
                    color: Color.fromARGB(255, 15, 158, 75),
                  ),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Container(
                  height: 45,
                  child: InkWell(
                    onTap: () {},
                    child: Center(
                      child: Text(
                        'Buy Now',
                        style: TextStyle(color: Colors.white, fontSize: 17),
                      ),
                    ),
                  ),
                  color: Color.fromARGB(255, 17, 61, 97),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void updateQuantity(int change) {
    setState(() {
      quantity += change;
      if (quantity < 1) {
        quantity = 1;
      }
    });
  }
}
