import 'package:flutter/material.dart';
import 'package:ibeuty/home.dart';

class SplashScreenPage extends StatelessWidget {
  // Simulate a time-consuming operation (e.g., loading resources, fetching data)
  Future<void> _mockFuture() async {
    await Future.delayed(Duration(seconds: 3));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Image.asset(
            'images/blue-wallpaper-1.jpg', // Replace with the path to your image
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          // Content on top of the background
          FutureBuilder(
            future: _mockFuture(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // While the future is still running, show a loading indicator or your logo
                return Center(
                  child: Container(
                    height: 100,
                    width: 180,
                    child: Image.asset('images/nologo.png'), // Replace with your logo
                  ),
                );
              } else {
                // When the future completes, navigate to the HomeScreen
                return Home();
              }
            },
          ),
        ],
      ),
    );
  }
}
