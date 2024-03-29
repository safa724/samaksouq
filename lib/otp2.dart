
import 'package:flutter/material.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({Key? key}) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Text(
              'Enter your OTP code here',
              style: TextStyle(
                color: Colors.black,
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OtpBox(),
                SizedBox(width: 10),
                OtpBox(),
                SizedBox(width: 10),
                OtpBox(),
                SizedBox(width: 10),
                OtpBox(),
                SizedBox(width: 10),
                OtpBox(),
                SizedBox(width: 10),
                OtpBox(),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Add your verification logic here
              },
              style: ElevatedButton.styleFrom(
              //  primary: Color.fromARGB(255, 5, 55, 97),
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
               
              ),
              child: Text(
                'Verify',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OtpBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromARGB(255, 8, 69, 119), width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double _preferredHeight = 350.0;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color.fromARGB(255, 5, 55, 95),
      title: Text(
        'Phone Verification',
        style: TextStyle(color: Colors.white),
      ),
      centerTitle: true,
      shape: CustomShapeBorder(), // Set custom shape here
      flexibleSpace: Container(
        height: _preferredHeight,
        child: Center(
          child: Image.asset(
            'images/logo.png',
            height: 40,
            width: 40,
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(_preferredHeight);
}

class CustomShapeBorder extends ContinuousRectangleBorder {
  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return getClip(Size(rect.width, rect.height));
  }

  Path getClip(Size size) {
    double radius = 24.0;
    Path path = Path();
    path.lineTo(0, size.height - radius);
    path.quadraticBezierTo(0, size.height, radius, size.height);
    path.lineTo(size.width - radius, size.height);
    path.quadraticBezierTo(
        size.width, size.height, size.width, size.height - radius);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }
}

