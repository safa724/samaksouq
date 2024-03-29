import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ibeuty/login.dart';

class OtpScreen extends StatefulWidget {
  final String verificationId;

  const OtpScreen({Key? key, required this.verificationId}) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  String _otp = "";
  List<TextEditingController> _controllers =
      List.generate(6, (index) => TextEditingController());
  String _errorMessage = "";

  Future<void> _verifyOTP(String otp) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: widget.verificationId,
      smsCode: otp,
    );
    try {
      await _auth.signInWithCredential(credential);
      print('OTP Verification Successful');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Login(initialPage: 'home')),
      );
    } catch (e) {
      print('Error verifying OTP: $e');
      setState(() {
        _errorMessage = "Error verifying OTP. Please try again.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
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
                  for (int i = 0; i < 6; i++)
                    Row(
                      children: [
                        OtpBox(controller: _controllers[i]),
                        SizedBox(width: 10), // Adjust width as needed
                      ],
                    ),
                ],
              ),
              SizedBox(height: 10),
              if (_errorMessage.isNotEmpty)
                Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  _otp = _controllers.map((controller) => controller.text).join();
                  _verifyOTP(_otp);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 5, 40, 70),
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
      ),
    );
  }
}

class OtpBox extends StatefulWidget {
  final TextEditingController controller;

  const OtpBox({Key? key, required this.controller}) : super(key: key);

  @override
  _OtpBoxState createState() => _OtpBoxState();
}

class _OtpBoxState extends State<OtpBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 60, // Adjusted height to provide space between boxes
      margin: EdgeInsets.symmetric(horizontal: 4), // Added margin for spacing
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromARGB(255, 8, 69, 119), width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: TextField(
          controller: widget.controller,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          cursorColor: Colors.black, // Set cursor color
          showCursor: true, // Ensure cursor is shown
           cursorHeight: 20,
        
          onChanged: (value) {
            if (value.isNotEmpty) {
              FocusScope.of(context).nextFocus();
            }
          },
          style: TextStyle(fontSize: 20),
          decoration: InputDecoration(
            counter: Offstage(),
            border: InputBorder.none,
            contentPadding: EdgeInsets.zero, // Remove default padding
          ),
        ),
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