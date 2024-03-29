import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ibeuty/home.dart';
import 'package:ibeuty/userprofile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppDrawer extends StatefulWidget {
  
  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
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
  @override
  Widget build(BuildContext context) {
    return Drawer(
  child: ListView(
    children: <Widget>[
      Container(
      color: Colors.white,
        height: 170,
        width: 150,
        child: Padding(
          padding: EdgeInsets.all(30),
          child: Column(
            
            children: [
          
              Row(
                children: [
                 Container(
                  height: 70,
                  width: 70,
                  color: Colors.white,
                  child: Image.asset('images/person.png')
                 ),
                 SizedBox(
                  width: 30,
                 ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        
                        ),
                      ),
                      Text(
                        userEmail,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                        
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      
    
        
      ),
     
      ListTile(
        onTap: () {
          Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Home()),
    );
        },
        leading: Icon(Icons.home_filled,color: Colors.grey),
        title: Text("Home",style: TextStyle(color: Colors.grey),),
      ),
      ListTile(
        onTap: () {
           Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UserProfileScreen())
    );
        },
       leading: Icon(Icons.person,color: Colors.grey),
        title: Text("Profile",style: TextStyle(color: Colors.grey),),
      ),
      ListTile(
        onTap: () {
    //       Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => UserProfileScreen())
    // );
        },
        leading: Icon(Icons.menu,color: Colors.grey),
        title: Text("Orders",style: TextStyle(color: Colors.grey),),
      ),
       ListTile(
        onTap: () {
    //       Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => UserProfileScreen())
    // );
        },
        leading: Icon(Icons.favorite_outline,color: Colors.grey,),
        title: Text("My Wishlist",style: TextStyle(color: Colors.grey),),
      ),
     ListTile(
  onTap: () {
    // Handle Logout functionality
    exit(0); // Exit the application
  },
  leading: Icon(Icons.login_outlined,color:Colors.grey),
  title: Text("Logout",style: TextStyle(color: Colors.grey),),
),
    ],
  ),
);
  }
}