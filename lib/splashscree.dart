import 'package:flutter/material.dart';
import 'package:ibeuty/home.dart';

class SplashScreenPage extends StatelessWidget {
  Future<void> _mockFuture() async {
    await Future.delayed(Duration(seconds: 3));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'images/blue-wallpaper-1.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          FutureBuilder(
            future: _mockFuture(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Container(
                    height: 100,
                    width: 180,
                    child: Image.asset('images/nologo.png'),
                  ),
                );
              } else {
                return Home();
              }
            },
          ),
        ],
      ),
    );
  }
}
