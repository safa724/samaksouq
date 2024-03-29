import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'models/bannermodel.dart';
import 'models/productmodel.dart';

class ApiService {
  List<BannerModel> banners = [];
  List<Product> products = [];
  List<Product> featuredProducts = []; 
  List <Product> todaydealProducts =[];
  List <Product> todaydeallimProducts =[];
  List <Product> bestSellingProducts =[];
  List <Product> bestSellinglimProducts =[];
  List <Product> featuredlimProducts =[];
   int currentPage = 1;

  

   Future<void> fetchBanners(BuildContext context) async {
    final String bannersUrl = 'https://samaksouq.com/api/v2/banners';

    try {
      final http.Response bannersResponse = await http.get(Uri.parse(bannersUrl));

      if (bannersResponse.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(bannersResponse.body);

        if (responseData.containsKey('data') && responseData['data'] is List) {
          final List<dynamic> bannersJson = responseData['data'];
          banners = bannersJson.map((json) => BannerModel.fromJson(json)).toList();
        } else {
          print('Error parsing banners data - Invalid format');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error parsing banners data'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      } else {
        print('Error fetching banners - Status Code: ${bannersResponse.statusCode}');
        print(bannersResponse.body);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error fetching banners'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (error) {
      print('Error fetching banners: $error');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error fetching banners'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

Future<void> fetchProducts(BuildContext context) async {
  final String productsUrl = 'https://samaksouq.com/api/v2/products?location_id=4125';

  try {
    final http.Response productsResponse = await http.get(
      Uri.parse(productsUrl),
      headers: {'Content-Type': 'application/json'},
   
    );

    if (productsResponse.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(productsResponse.body);

      // Check if 'data' key exists and is a list
      if (responseData.containsKey('data') && responseData['data'] is List) {
        final List<dynamic> productsJson = responseData['data'];
        products = productsJson.map((json) => Product.fromJson(json)).toList();
      } else {
        print('Error parsing products data - Invalid format');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error parsing products data'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } else {
      print('Error fetching products - Status Code: ${productsResponse.statusCode}');
      print(productsResponse.body);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error fetching products'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  } catch (error) {
    print('Error fetching products: $error');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error fetching products'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
Future<void> fetchFeaturedProducts(BuildContext context) async {
  final String featuredProductsUrl = 'https://samaksouq.com/api/v2/products/featured?location_id=4125';

  try {
    final http.Response featuredProductsResponse = await http.get(Uri.parse(featuredProductsUrl), headers: {'Content-Type': 'application/json'});

    if (featuredProductsResponse.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(featuredProductsResponse.body);

      if (responseData.containsKey('data') && responseData['data'] is List) {
        final List<dynamic> featuredProductsJson = responseData['data'];
        featuredProducts = featuredProductsJson.map((json) => Product.fromJson(json)).toList();
      } else {
        print('Error parsing featured products data - Invalid format');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error parsing featured products data'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } else {
      print('Error fetching featured products - Status Code: ${featuredProductsResponse.statusCode}');
      print(featuredProductsResponse.body);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error fetching featured products'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  } catch (error) {
    print('Error fetching featured products: $error');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error fetching featured products'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
Future<void> fetchTodaydeallimProducts(BuildContext context) async {
  final String todaydeallimProductsUrl = 'https://samaksouq.com/api/v2/products/todays-deal/limit?location_id=4125';

  try {
    final http.Response todaydeallimProductsResponse = await http.get(Uri.parse(todaydeallimProductsUrl), headers: {'Content-Type': 'application/json'});

    if (todaydeallimProductsResponse.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(todaydeallimProductsResponse.body);

      if (responseData.containsKey('data') && responseData['data'] is List) {
        final List<dynamic> todaydeallimProductsJson = responseData['data'];
        todaydeallimProducts = todaydeallimProductsJson.map((json) => Product.fromJson(json)).toList();
      } else {
        print('Error parsing limited products data - Invalid format');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error parsing limited products data'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } else {
      print('Error fetching limited products - Status Code: ${todaydeallimProductsResponse.statusCode}');
      print(todaydeallimProductsResponse.body);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error fetching limited products'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  } catch (error) {
    print('Error fetching limited products: $error');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error fetching limited products'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}

Future<void> fetchfeaturedlimProducts(BuildContext context) async {
  final String featuredlimProductsUrl = 'https://samaksouq.com/api/v2/products/featured/limit?location_id=4125';

  try {
    final http.Response featuredlimProductsResponse = await http.get(Uri.parse(featuredlimProductsUrl), headers: {'Content-Type': 'application/json'});

    if (featuredlimProductsResponse.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(featuredlimProductsResponse.body);

      if (responseData.containsKey('data') && responseData['data'] is List) {
        final List<dynamic> featuredlimProductsJson = responseData['data'];
        featuredlimProducts = featuredlimProductsJson.map((json) => Product.fromJson(json)).toList();
      } else {
        print('Error featuredlim products data - Invalid format');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error parsing featuredlim products data'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } else {
      print('Error fetching limited products - Status Code: ${featuredlimProductsResponse.statusCode}');
      print(featuredlimProductsResponse.body);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error fetching limited products'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  } catch (error) {
    print('Error fetching limited products: $error');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error fetching limited products'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}

Future<void> fetchTodaydealProducts(BuildContext context) async {
  final String todaydealProductsUrl = 'https://samaksouq.com/api/v2/products/todays-deal?location_id=4125';

  try {
    final http.Response todaydealProductsResponse = await http.get(Uri.parse(todaydealProductsUrl), headers: {'Content-Type': 'application/json'});

    if (todaydealProductsResponse.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(todaydealProductsResponse.body);

      if (responseData.containsKey('data') && responseData['data'] is List) {
        final List<dynamic> todaydealProductsJson = responseData['data'];
        todaydealProducts = todaydealProductsJson.map((json) => Product.fromJson(json)).toList();
      } else {
        print('Error parsing featured products data - Invalid format');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error parsing featured products data'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } else {
      print('Error fetching featured products - Status Code: ${todaydealProductsResponse.statusCode}');
      print(todaydealProductsResponse.body);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error fetching featured products'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  } catch (error) {
    print('Error fetching featured products: $error');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error fetching featured products'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
Future<void> fetchBestSellinglimProducts(BuildContext context) async {
  final String bestSellinglimProductsUrl = 'https://samaksouq.com/api/v2/products/best-seller/limit?location_id=4125';

  try {
    final http.Response bestSellinglimProductsResponse = await http.get(Uri.parse(bestSellinglimProductsUrl), headers: {'Content-Type': 'application/json'});

    if (bestSellinglimProductsResponse.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(bestSellinglimProductsResponse.body);

      if (responseData.containsKey('data') && responseData['data'] is List) {
        final List<dynamic> bestSellinglimProductsJson = responseData['data'];
        bestSellinglimProducts = bestSellinglimProductsJson.map((json) => Product.fromJson(json)).toList();
      } else {
        print('Error parsing best-selling lim products data - Invalid format');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error parsing best-selling lim products data'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } else {
      print('Error fetching best-selling lim products - Status Code: ${bestSellinglimProductsResponse.statusCode}');
      print(bestSellinglimProductsResponse.body);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error fetching best-selling lim products'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  } catch (error) {
    print('Error fetching best-selling products: $error');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error fetching best-selling products'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}

// Future<void> fetchBestSellingProducts(BuildContext context) async {
//   final String bestSellingProductsUrl = 'https://samaksouq.com/api/v2/products/best-seller?location_id=4125';

//   try {
//     final http.Response bestSellingProductsResponse = await http.get(Uri.parse(bestSellingProductsUrl), headers: {'Content-Type': 'application/json'});

//     if (bestSellingProductsResponse.statusCode == 200) {
//       final Map<String, dynamic> responseData = json.decode(bestSellingProductsResponse.body);

//       if (responseData.containsKey('data') && responseData['data'] is List) {
//         final List<dynamic> bestSellingProductsJson = responseData['data'];
//         bestSellingProducts = bestSellingProductsJson.map((json) => Product.fromJson(json)).toList();
//       } else {
//         print('Error parsing best-selling products data - Invalid format');
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Error parsing best-selling products data'),
//             duration: Duration(seconds: 2),
//           ),
//         );
//       }
//     } else {
//       print('Error fetching best-selling products - Status Code: ${bestSellingProductsResponse.statusCode}');
//       print(bestSellingProductsResponse.body);

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Error fetching best-selling products'),
//           duration: Duration(seconds: 2),
//         ),
//       );
//     }
//   } catch (error) {
//     print('Error fetching best-selling products: $error');

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('Error fetching best-selling products'),
//         duration: Duration(seconds: 2),
//       ),
//     );
//   }
// }


}
