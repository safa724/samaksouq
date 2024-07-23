import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ibeuty/login.dart';
import 'package:ibeuty/otp.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  String _phoneNumber = "";
  String _name = "";
  String _verificationId = "";

  Future<void> _sendOTP() async {
    try {
      String formattedPhoneNumber =
          "+966" + _phoneNumber.replaceAll(RegExp(r'\D'), '');

      await _auth.verifyPhoneNumber(
        phoneNumber: formattedPhoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {
          print(e.message);
        },
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            _verificationId = verificationId;
          });
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    OtpScreen(verificationId: _verificationId)),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          setState(() {
            _verificationId = verificationId;
          });
        },
      );
    } catch (e) {
      print('Error sending OTP: $e');
    }
  }

  Future<void> _signup() async {
    try {
      String formattedPhoneNumber =
          "+966" + _phoneNumber.replaceAll(RegExp(r'\D'), '');

      var url = Uri.parse('https://samaksouq.com/api/v2/auth/signup');
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'X-Requested-With': 'XMLHttpRequest',
        },
        body: jsonEncode({
          'name': _name,
          'email_or_phone': formattedPhoneNumber,
          'password': '123456',
          'register_by': 'phone',
        }),
      );

      if (response.statusCode == 201) {
        print('Sign Up Successful');
        print(response.body);
        print('OTP Sent');
        await _sendOTP();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sign Up Successful. OTP Sent.'),
            backgroundColor: Colors.green,
          ),
        );
      } else if (response.statusCode == 400) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Invalid credentials. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      } else if (response.statusCode == 409) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('User already exists. Please log in.'),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        print('Failed to initiate signup: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 150),
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
                'Join Samaksouq',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 3, 73, 129),
                    fontSize: 20),
              ),
              SizedBox(height: 10),
              Column(children: [
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text("           Name",
                        style: TextStyle(
                            color: const Color.fromARGB(255, 8, 78, 134),
                            fontWeight: FontWeight.w700))),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  width: 300,
                  height: 45,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              _name = value;
                            });
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text("           phone",
                        style: TextStyle(
                            color: const Color.fromARGB(255, 8, 78, 134),
                            fontWeight: FontWeight.w700))),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  width: 300,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:
                            Text("+966", style: TextStyle(color: Colors.black)),
                      ),
                      VerticalDivider(
                        color: Colors.grey,
                        thickness: 1.0,
                        width: 1.0,
                      ),
                      Expanded(
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              _phoneNumber = value;
                            });
                          },
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                InkWell(
                  onTap: _signup,
                  child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 21, 81, 129),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      width: 300,
                      child: Center(
                          child: Text(
                        'Sign Up',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 16),
                      ))),
                ),
                SizedBox(height: 15),
                Text('              Already have an Account ?',
                    style: TextStyle(color: Colors.grey)),
                InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Login(initialPage: 'home')));
                    },
                    child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 21, 81, 129),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        width: 300,
                        child: Center(
                            child: Text('Log in',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 16))))),
              ])
            ],
          ),
        ),
      ),
    );
  }
}
