import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ibeuty/details1.dart';
import 'package:ibeuty/models/productmodel.dart';

class TodayDeal extends StatefulWidget {
  final String locationId;

  const TodayDeal({Key? key, required this.locationId}) : super(key: key);

  @override
  State<TodayDeal> createState() => _TodayDealState();
}

class _TodayDealState extends State<TodayDeal> {
  List<Product> todaydealProducts = [];
  bool isLoading = false; // Add isLoading variable

  @override
  void initState() {
    super.initState();
    fetchTodaydealProducts(widget.locationId);
  }

  Future<void> fetchTodaydealProducts(String locationId) async {
    setState(() {
      isLoading = true; // Set isLoading to true when API call starts
    });

    final String todaydealProductsUrl =
        'https://samaksouq.com/api/v2/products/todays-deal?location_id=$locationId';

    try {
      final http.Response todaydealProductsResponse =
          await http.get(Uri.parse(todaydealProductsUrl),
              headers: {'Content-Type': 'application/json'});

      if (todaydealProductsResponse.statusCode == 200) {
        final Map<String, dynamic> responseData =
            json.decode(todaydealProductsResponse.body);

        if (responseData.containsKey('data') && responseData['data'] is List) {
          final List<dynamic> todaydealProductsJson = responseData['data'];
          setState(() {
            todaydealProducts = todaydealProductsJson
                .map((json) => Product.fromJson(json))
                .toList();
          });
        } else {
          print('Error parsing featured products data - Invalid format');
        }
      } else {
        print(
            'Error fetching featured products - Status Code: ${todaydealProductsResponse.statusCode}');
        print(todaydealProductsResponse.body);
      }
    } catch (error) {
      print('Error fetching featured products: $error');
    } finally {
      setState(() {
        isLoading = false; // Set isLoading to false when API call ends
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Todays Deals',
          style: TextStyle(color: Color.fromARGB(255, 4, 74, 131)),
        ),
      ),
      body: isLoading // Display loader if isLoading is true
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(10.0),
              child: GridView.count(
                crossAxisCount: 2,
                children: todaydealProducts.map((product) {
                  return ProductCard(
                    product: product,
                    products: todaydealProducts,
                  );
                }).toList(),
              ),
            ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;

  final List<Product> products;

  ProductCard({required this.product, required this.products});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        int selectedProductIndex = products.indexOf(product);

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(products: products, selectedProductIndex: selectedProductIndex)
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Color.fromARGB(255, 221, 218, 218),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                  image: DecorationImage(
                    image: NetworkImage(product.thumbnailImage),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    product.name,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    product.mainPrice,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      color: Color.fromARGB(255, 2, 67, 119),
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
