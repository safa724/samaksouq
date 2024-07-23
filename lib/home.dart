import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ibeuty/apiservice.dart';
import 'package:ibeuty/bar.dart';
import 'package:ibeuty/cart1.dart';
import 'package:ibeuty/category.dart';
import 'package:ibeuty/details1.dart';
import 'package:ibeuty/drawer.dart';
import 'package:ibeuty/location.dart';
import 'package:ibeuty/models/productmodel.dart';
import 'package:ibeuty/todaysdeal.dart';
import 'package:ibeuty/userprofile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final CarouselController _carouselController = CarouselController();

  bool isLoading = true;
  List<Product> products = [];
  int currentIndex = 0;
  ApiService apiService = ApiService();
  List<Product> todayDeallimProducts = [];
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  String userName = '';
  String userEmail = '';
  bool isLoggedIn = false;
  String selectedLocationName = '';
  String selectedLocationId = '4125';
  bool isLocationSelected = false;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
    fetchLocationsAndLoadProducts();
  }

  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
      if (isLoggedIn) {
        userName = prefs.getString('userName') ?? '';
        userEmail = prefs.getString('userEmail') ?? '';
      }
    });
  }

  Future<void> fetchLocationsAndLoadProducts() async {
    try {
      final response = await http
          .get(Uri.parse('http://samaksouq.com/api/v2/seller_location'));
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        List<Map<String, dynamic>> locations =
            List<Map<String, dynamic>>.from(responseData['location']);

        if (locations.isNotEmpty) {
          Map<String, dynamic> defaultLocation = locations[0];
          selectLocation(defaultLocation);
        }
      } else {
        print('Failed to load locations');
      }
    } catch (error) {
      print('Error fetching locations: $error');
    }
  }

  void selectLocation(Map<String, dynamic> selectedLocation) {
    if (selectedLocation != null) {
      setState(() {
        selectedLocationId = selectedLocation['id'].toString();
        selectedLocationName = selectedLocation['name'];
        isLocationSelected = true;
      });
      fetchData(selectedLocationId);
    }
  }

  Future<void> fetchTodayDeallimProducts(String locationId) async {
    final String todayDeallimProductsUrl =
        'https://samaksouq.com/api/v2/products/todays-deal/limit?location_id=$locationId';
    try {
      final http.Response todayDeallimProductsResponse = await http.get(
          Uri.parse(todayDeallimProductsUrl),
          headers: {'Content-Type': 'application/json'});

      if (todayDeallimProductsResponse.statusCode == 200) {
        final Map<String, dynamic> responseData =
            json.decode(todayDeallimProductsResponse.body);

        if (responseData.containsKey('data') && responseData['data'] is List) {
          final List<dynamic> todayDeallimProductsJson = responseData['data'];
          todayDeallimProducts = todayDeallimProductsJson
              .map((json) => Product.fromJson(json))
              .toList();
        } else {
          print('Error parsing today deal products data - Invalid format');
        }
      } else {
        print(
            'Error fetching today deal products - Status Code: ${todayDeallimProductsResponse.statusCode}');
        print(todayDeallimProductsResponse.body);
      }
    } catch (error) {
      print('Error fetching today deal products: $error');
    }
  }

  void fetchData(String locationId) async {
    setState(() {
      isLoading = true;
    });
    try {
      await apiService.fetchBanners(context);
      await fetchTodayDeallimProducts(locationId);
      setState(() {
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
          endDrawer: AppDrawer(),
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(130.0),
            child: AppBar(
              automaticallyImplyLeading: false,
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color.fromARGB(255, 2, 67, 119), Colors.white],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              elevation: 0,
              centerTitle: true,
              title: Row(
                children: [
                  InkWell(
                    onTap: () async {
                      final selectedLocation = await Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => LocationScreen()),
                      );
                      selectLocation(selectedLocation);
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.location_pin,
                          color: Colors.white,
                          size: 14,
                        ),
                        SizedBox(width: 5),
                        Text(
                          selectedLocationName,
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        ),
                        Icon(
                          Icons.arrow_right_sharp,
                          color: Colors.white,
                          size: 14,
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Image.asset('images/newlogo.png', height: 30),
                  Spacer(),
                ],
              ),
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(50),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 13.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.search),
                        ),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Search for products',
                              hintStyle: TextStyle(fontFamily: 'Montserrat'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          body: isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Color.fromARGB(255, 2, 67, 119)),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        CarouselSlider(
                          options: CarouselOptions(
                            height: 145.0,
                            aspectRatio: 16 / 9,
                            autoPlay: false,
                            enlargeCenterPage: true,
                            onPageChanged: (index, reason) {
                              setState(() {
                                _currentIndex = index;
                              });
                            },
                            viewportFraction: 1.0,
                          ),
                          items: apiService.banners.map((banner) {
                            return Builder(
                              builder: (BuildContext context) {
                                return Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      fit: BoxFit.fill,
                                      banner.photo,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Center(
                                          child: Text('Image not available'),
                                        );
                                      },
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        } else {
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                );
                              },
                            );
                          }).toList(),
                        ),

                        SizedBox(
                          height: 15,
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            apiService.banners.length,
                            (index) => Container(
                              width: 20.0,
                              height: 5.0,
                              margin: EdgeInsets.symmetric(horizontal: 2.0),
                              decoration: BoxDecoration(
                                color: _currentIndex == index
                                    ? Color.fromARGB(255, 4, 79, 141)
                                    : Colors.grey,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(
                          height: 13,
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Row(
                            children: [
                              Text(
                                'Todays Deal',
                                style: TextStyle(
                                  fontSize: 17,
                                ),
                              ),
                              Spacer(),
                              Text(
                                'View All',
                                style: TextStyle(
                                  fontSize: 17,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => TodayDeal(
                                            locationId: selectedLocationId)),
                                  );
                                },
                                icon: Icon(
                                  Icons.arrow_circle_right_sharp,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ),

                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: todayDeallimProducts.map((product) {
                              return SizedBox(
                                width: 150,
                                child: ProductCard(
                                    product: product,
                                    products: todayDeallimProducts),
                              );
                            }).toList(),
                          ),
                        ),
                        //           SizedBox(height: 13,),
                        //           Align(
                        //             alignment: Alignment.topLeft,
                        //             child: Text('Top Selling',style: TextStyle(fontSize: 17,),)),

                        //          SingleChildScrollView(
                        //   scrollDirection: Axis.horizontal,
                        //   child: Row(
                        //     children: apiService.bestSellinglimProducts.map((product) {
                        //       return SizedBox(
                        //         width: 150,
                        //         child: ProductCard(product: product, products: apiService.bestSellinglimProducts),
                        //       );
                        //     }).toList(),
                        //   ),
                        // ),

                        //             SizedBox(height: 13,),
                        //           Align(
                        //             alignment: Alignment.topLeft,
                        //             child: Text('Trending',style: TextStyle(fontSize: 17,),)),
                        //               SingleChildScrollView(
                        //   scrollDirection: Axis.vertical,
                        //   child: Column(
                        //     children: List.generate(
                        //       (apiService.featuredlimProducts.length / 2).ceil(),
                        //       (index) {
                        //         int startIndex = index * 2;
                        //         int endIndex = (startIndex + 2 <= apiService.featuredlimProducts.length)
                        //             ? startIndex + 2
                        //             : apiService.featuredlimProducts.length;

                        //         return Row(

                        //           children: apiService.featuredlimProducts
                        //               .sublist(startIndex, endIndex)
                        //               .map((product) {
                        //                 return SizedBox(
                        //                   width: 164,
                        //                   height: 230,
                        //                   child: ProductCard(product: product, products: apiService.featuredlimProducts),
                        //                 );
                        //               })
                        //               .toList(),
                        //         );
                        //       },
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
          bottomNavigationBar: CustomBottomNavigationBar(
            currentIndex: 0,
            onTap: (int index) {
              if (index == 1) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => CategoryScreen()),
                );
              } else if (index == 3) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => CartPage()),
                );
              } else if (index == 4) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => UserProfileScreen()),
                );
              }
            },
          )),
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
              builder: (context) => ProductDetailScreen(
                  products: products,
                  selectedProductIndex: selectedProductIndex)),
        );
      },
      child: Container(
        margin: EdgeInsets.all(8),
        height: 200,
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 100,
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
                        fontSize: 11, color: Color.fromARGB(255, 2, 67, 119)),
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
