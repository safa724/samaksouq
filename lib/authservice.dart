// import 'package:shared_preferences/shared_preferences.dart';

// class AuthService {
//   static Future<bool> isLoggedIn() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.getBool('isLoggedIn') ?? false;
//   }

//   static Future<String?> getUserId() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.getString('userId');
//   }

//   static Future<void> setUserId(String userId) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setString('userId', userId);
//   }
//   static const String _accessTokenKey = 'accessToken';

//   static Future<String?> getAccessToken() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.getString(_accessTokenKey);
//   }

//   static Future<void> setAccessToken(String accessToken) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setString(_accessTokenKey, accessToken);
//   }
// }
