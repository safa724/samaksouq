import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ibeuty/models/addressmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddressService {
  final String accessToken;
  late String userId;
  AddressService(this.accessToken);
Future<void> getUserIdFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    
      userId = prefs.getString('userId') ?? ''; // Retrieve user ID from SharedPreferences
    
      
    
  }
  Future<List<Address>> getUserAddresses() async {
    try {
      final response = await http.get(
        Uri.parse('https://www.samaksouq.com/api/v2/user/shipping/address'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final dynamic jsonResponse = json.decode(response.body);
        final List<dynamic> data = jsonResponse['data'];
        return data.map((addressData) => Address.fromJson(addressData)).toList();
      } else {
        throw Exception('Failed to load addresses: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error loading addresses: $error');
    }
  }

Future<void> addUserAddress(String address, String phone) async {
  try {
    await getUserIdFromSharedPreferences(); // Initialize userId
    
    final response = await http.post(
      Uri.parse('https://www.samaksouq.com/api/v2/user/shipping/create'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode({
        "user_id": userId, // Now userId is initialized
        "address": address,
        "country_id": "101",
        "city_id": "48359",
        "state_id": "4125",
        "postal_code": "680001",
        "phone": phone,
        "latitude": "37.7749",
        "longitude": "-122.4194"
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to add address: ${response.statusCode}');
    }
  } catch (error) {
    throw Exception('Error adding address: $error');
  }
}
}