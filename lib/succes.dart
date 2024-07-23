import 'package:flutter/material.dart';
import 'package:ibeuty/home.dart';

class PaymentSuccessfulPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'images/gifgif.gif',
              width: 250,
              height: 250,
            ),
            Text(
              'Your order has been successfully placed!',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green),
            ),
            SizedBox(height: 10),
            SizedBox(height: 20),
            InkWell(
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Home()));
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 21, 81, 129),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                height: 50,
                width: 160,
                child: Center(
                    child: Text(
                  'Continue Shopping',
                  style: TextStyle(color: Colors.white),
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
