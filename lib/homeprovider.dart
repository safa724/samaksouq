// import 'package:flutter/material.dart';
// import 'package:ibeuty/apiservice.dart';
// import 'package:ibeuty/models/bannermodel.dart';
// import 'package:ibeuty/models/productmodel.dart';


// class HomeProvider with ChangeNotifier {
//   final ApiService _apiService = ApiService();

//   // Banner data
//   List<BannerModel> _banners = [];
//   List<BannerModel> get banners => _banners;

//   // Products data
//   List<Product> _products = [];
//   List<Product> get products => _products;

//   // Featured products data
//   List<Product> _featuredProducts = [];
//   List<Product> get featuredProducts => _featuredProducts;

//   // Today deal products data
//   List<Product> _todayDealProducts = [];
//   List<Product> get todayDealProducts => _todayDealProducts;

//   // Best selling products data
//   List<Product> _bestSellingProducts = [];
//   List<Product> get bestSellingProducts => _bestSellingProducts;

//   // Loading state
//   bool _isLoading = true;
//   bool get isLoading => _isLoading;

//   // Fetch data method
//   Future<void> fetchData(BuildContext context) async {
//     try {
//       _isLoading = true;
//       notifyListeners();

//       // Fetch all necessary data using ApiService
//       await _apiService.fetchBanners(context);
//       await _apiService.fetchProducts(context);
//       await _apiService.fetchFeaturedProducts(context);
//       await _apiService.fetchTodaydealProducts(context);
//       await _apiService.fetchBestSellingProducts(context);

//       // Assign fetched data to provider variables
//       _banners = _apiService.banners;
//       _products = _apiService.products;
//       _featuredProducts = _apiService.featuredProducts;
//       _todayDealProducts = _apiService.todaydealProducts;
//       _bestSellingProducts = _apiService.bestSellingProducts;

//       _isLoading = false;
//       notifyListeners();
//     } catch (error) {
//       print('Error fetching home screen data: $error');

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Error fetching home screen data'),
//           duration: Duration(seconds: 2),
//         ),
//       );

//       _isLoading = false;
//       notifyListeners();
//     }
//   }
// }
