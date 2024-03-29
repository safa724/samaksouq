import 'dart:collection';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CartProvider with ChangeNotifier {
  List<dynamic> _cartItems = [];
  bool _isLoggedIn = false;
  int _cartItemCount = 0; // Initialize cart item count to 0
  bool _isRequestPending = false; // Flag to track whether a request is pending
  Queue<Function> _requestQueue = Queue(); // Queue to store pending requests
  double _totalAmount = 0.0;
  double get totalAmount => _totalAmount;

  List<dynamic> get cartItems => _cartItems;
  int get cartItemCount => _cartItemCount;
  bool get isLoggedIn => _isLoggedIn;

  CartProvider() {
    // Fetch cart items when the provider is initialized
    checkLoginStatus();
    fetchCartItems();
  }

  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    notifyListeners();
  }

 Future<void> fetchCartItems() async {
  try {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String accessToken = prefs.getString('accessToken') ?? '';
    if (accessToken.isEmpty) {
      print('Access token is empty!');
      return;
    }

    final response = await http.post(
      Uri.parse('https://www.samaksouq.com/api/v2/carts'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> responseData = jsonDecode(response.body);
      if (responseData.isNotEmpty) {
        // Store owner ID in SharedPreferences
        int ownerId = responseData[0]['owner_id'];
        await prefs.setInt('ownerId', ownerId);
      }

      _cartItems = responseData;
      // Update cart item count after fetching cart items
      _updateCartItemCount();
      notifyListeners();
      _processRequestQueue(); // Process pending requests
    } else {
      print('Failed to fetch cart items: ${response.statusCode}');
      print('Response body: ${response.body}');
      // Additional error handling based on response status code
      if (response.statusCode == 401) {
        // Unauthorized, handle accordingly (e.g., logout user)
      }
      // Add more error handling for other status codes if needed
    }
  } catch (error) {
    print('Error fetching cart items: $error');
  }
}


  void _updateCartItemCount() {
    // Calculate cart item count based on the length of _cartItems
    _cartItemCount = _cartItems.length;
  }

  // Method to add requests to the queue
  void _addToRequestQueue(Function requestFunction) {
    _requestQueue.add(requestFunction);
    if (!_isRequestPending) {
      _processRequestQueue();
    }
  }

  // Method to process requests in the queue sequentially
  void _processRequestQueue() async {
    if (_requestQueue.isEmpty) {
      _isRequestPending = false;
      return;
    }
    _isRequestPending = true;
    Function request = _requestQueue.removeFirst();
    await request();
    _processRequestQueue(); // Process next request
  }

  // Method to update the quantity of an item in the cart
  Future<void> updateCartItemQuantity(String cartId, int quantity) async {
    _addToRequestQueue(() async {
      try {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        String accessToken = prefs.getString('accessToken') ?? '';
        if (accessToken.isEmpty) {
          print('Access token is empty!');
          return;
        }

        final response = await http.post(
          Uri.parse('https://www.samaksouq.com/api/v2/carts/process'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken',
          },
          body: jsonEncode({
            'cart_ids': cartId,
            'cart_quantities': quantity.toString(),
          }),
        );

        if (response.statusCode == 200) {
          print('Cart item quantity updated successfully');
          fetchCartItems(); // Fetch updated cart items after successful update
        } else {
          print('Failed to update cart item quantity: ${response.statusCode}');
          print('Response body: ${response.body}');
          // Handle error response
        }
      } catch (error) {
        print('Error updating cart item quantity: $error');
      }
    });
  }

  // Method to remove an item from the cart
  Future<void> removeItemFromCart(String itemId, int index) async {
    _addToRequestQueue(() async {
      try {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        String accessToken = prefs.getString('accessToken') ?? '';
        if (accessToken.isEmpty) {
          print('Access token is empty!');
          return;
        }

        final response = await http.post(
          Uri.parse('https://www.samaksouq.com/api/v2/removecart'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken',
          },
          body: jsonEncode({
            'id': itemId,
          }),
        );

        if (response.statusCode == 200) {
          print('Item removed successfully');
          fetchCartItems(); // Fetch updated cart items after successful removal
        } else {
          print('Failed to remove item from cart: ${response.statusCode}');
          print('Response body: ${response.body}');
          // Handle error response
        }
      } catch (error) {
        print('Error removing item from cart: $error');
      }
    });
  }
}
