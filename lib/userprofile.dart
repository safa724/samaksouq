import 'package:flutter/material.dart';
import 'package:ibeuty/bar.dart';
import 'package:ibeuty/cart1.dart';
import 'package:ibeuty/category.dart';
import 'package:ibeuty/home.dart';
import 'package:ibeuty/login.dart';
import 'package:ibeuty/models/productmodel.dart';
import 'package:ibeuty/oderdetails.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfileScreen extends StatefulWidget {
  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  List<Product> products = [];
  bool isLoggedIn = false;
  String userName = '';
  String userEmail = '';

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
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

  void _login() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Login(initialPage: 'home')),
    ).then((_) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 4,
        onTap: (int index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Home()),
            );
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => CategoryScreen()),
            );
          } else if (index == 3) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => CartPage()),
            );
          }
        },
      ),
      appBar: AppBar(
        title: Center(child: Text('Account')),
      ),
      body: isLoggedIn ? _buildUserProfile() : Login(initialPage: 'home'),
    );
  }

  Widget _buildUserProfile() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: CircleAvatar(
              radius: 50,
              child: Icon(
                Icons.person,
                size: 50,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 16),
          Center(
            child: Text(
              userName,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 8),
          Center(
            child: Text(
              userEmail,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ),
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text(
                      '00',
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      'In your Cart',
                      style: TextStyle(fontSize: 10, color: Colors.grey),
                    )
                  ],
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  children: [
                    Text(
                      '00',
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      'In your Wishlist',
                      style: TextStyle(fontSize: 10, color: Colors.grey),
                    )
                  ],
                ),
                SizedBox(width: 10),
                Column(
                  children: [
                    Text(
                      '00',
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      'Ordered',
                      style: TextStyle(fontSize: 10, color: Colors.grey),
                    )
                  ],
                )
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => OrderDetails()));
                },
                child: Column(
                  children: [
                    CircleAvatar(
                      backgroundColor: Color.fromARGB(255, 214, 214, 214),
                      radius: 25,
                      child: Icon(
                        Icons.shopping_bag_outlined,
                        size: 29,
                        color: Colors.green,
                      ),
                    ),
                    Text(
                      'Orders',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                width: 40,
              ),
              Column(
                children: [
                  CircleAvatar(
                    backgroundColor: Color.fromARGB(255, 214, 214, 214),
                    radius: 25,
                    child: Icon(
                      Icons.person_2,
                      size: 29,
                      color: Colors.blue,
                    ),
                  ),
                  Text(
                    'Profile',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  )
                ],
              ),
              SizedBox(
                width: 40,
              ),
              Column(
                children: [
                  CircleAvatar(
                    backgroundColor: Color.fromARGB(255, 214, 214, 214),
                    radius: 25,
                    child: Icon(
                      Icons.location_pin,
                      size: 29,
                      color: Color.fromARGB(255, 235, 217, 56),
                    ),
                  ),
                  Text(
                    'Address',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  )
                ],
              )
            ],
          ),
          SizedBox(
            height: 40,
          ),
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.green,
                radius: 23,
                child: Icon(Icons.attach_money_outlined,
                    size: 30, color: Colors.white),
              ),
              SizedBox(
                width: 15,
              ),
              Text(
                'Purchase History',
                style: TextStyle(
                  fontSize: 20,
                ),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.red,
                radius: 23,
                child: Icon(Icons.delete, size: 30, color: Colors.white),
              ),
              SizedBox(
                width: 15,
              ),
              Text(
                'Delete Account',
                style: TextStyle(
                  fontSize: 20,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
