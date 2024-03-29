import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ibeuty/home.dart';
import 'package:ibeuty/signup.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  final String initialPage; // Parameter to indicate initial page

  const Login({Key? key, required this.initialPage}) : super(key: key);
  
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController phoneController = TextEditingController();
  

 Future<void> signInUser() async {
  String phoneNumber = phoneController.text.trim();
  final response = await http.post(
    Uri.parse('https://www.samaksouq.com/api/v2/auth/login'),
    headers: {
      'Content-Type': 'application/json',
      'X-Requested-With': 'XMLHttpRequest',
    },
    body: jsonEncode({
      'email': phoneNumber,
      'password': '123456',
      'identity_matrix': 'ec669dad-9136-439d-b8f4-80298e7e6f37',
    }),
  );

  print('Response: ${response.body}'); // Print the entire response body

  if (response.statusCode == 200) {
    // Successful login
    Map<String, dynamic> responseData = json.decode(response.body);
    String accessToken = responseData['access_token'];
    String userId = responseData['user']['id'].toString();
    String userName = responseData['user']['name'];
    String userEmail = responseData['user']['email'];
    String userPhone = responseData['user']['phone'];

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', true);
    prefs.setString('userId', userId); 
    prefs.setString('userName', userName);
    prefs.setString('userEmail', userEmail);
    prefs.setString('accessToken', accessToken);
    prefs.setString('userPhone', userPhone);
    
    if (widget.initialPage == 'home') { // Change this condition to check if initialPage is home
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Home()), // Navigate to Home instead of AddressPage
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Home()), // Navigate to AddressPage as before
      );
    }
  } else {
    // Handle failed login
    print('Login Failed: ${response.reasonPhrase}');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Login Failed: ${response.reasonPhrase}')),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              
              children: [
                SizedBox(height: 100),
                ClipOval(
                  child: Image.asset(
                    'images/logo.png',
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  'Login to Samaksouq',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 3, 73, 129),
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "phone",
                          style: TextStyle(
                            color: const Color.fromARGB(255, 8, 78, 134),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          width: 300,
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "+966",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                              VerticalDivider(
                                color: Colors.grey,
                                thickness: 1.0,
                                width: 1.0,
                              ),
                              Expanded(
                                child: TextField(
                                  controller: phoneController,
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(
                                    
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Align(
                      //   alignment: Alignment.centerLeft,
                      //   child: Text(
                      //     "Password",
                      //     style: TextStyle(
                      //       color: const Color.fromARGB(255, 8, 78, 134),
                      //       fontWeight: FontWeight.w700,
                      //     ),
                      //   ),
                      // ),
                      // Align(
                      //   alignment: Alignment.centerLeft,
                      //   child: Container(
                      //     decoration: BoxDecoration(
                      //       border: Border.all(color: Colors.grey),
                      //       borderRadius: BorderRadius.circular(5.0),
                      //     ),
                      //     width: 300,
                      //     child: Row(
                      //       children: [
                      //         Expanded(
                      //           child: TextField(
                      //             controller: passwordController,
                      //             obscureText: true,
                      //             decoration: InputDecoration(
                                   
                      //               border: InputBorder.none,
                      //             ),
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      SizedBox(height: 40),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: InkWell(
                          onTap: signInUser,
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 21, 81, 129),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            width: 300,
                            child: Center(
                              child: Text(
                                'Log in',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '                  or ,create a new account ?',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => SignUp()),
                            );
                          },
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 21, 81, 129),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            width: 300,
                            child: Center(
                              child: Text(
                                'Sign up',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}