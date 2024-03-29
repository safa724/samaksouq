import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ibeuty/succes.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentScreen extends StatefulWidget {
  final String paymentUrl;

  const PaymentScreen({Key? key, required this.paymentUrl}) : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool _isLoading = true;
  final Completer<WebViewController> _controller = Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Pay with MADA',
          style: TextStyle(color: Color.fromARGB(255, 16, 82, 136)),
        ),
      ),
      body: Stack(
        children: [
          WebView(
            initialUrl: widget.paymentUrl,
            javascriptMode: JavascriptMode.unrestricted,
            onPageFinished: (url) {
              setState(() {
                _isLoading = false;
              });
            },
            onWebViewCreated: (WebViewController webViewController) {
              _controller.complete(webViewController);
            },
            navigationDelegate: (NavigationRequest request) async {
              if (request.url.startsWith('https://samaksouq.com/order-success')) {
                // Handle successful payment redirection
                // Navigate back to previous screen or show success message in your app
                // You can use Navigator.pop(context) to go back
                // Or display a success message using a dialog or a snackbar
                final WebViewController controller = await _controller.future;
                await controller.loadUrl('about:blank'); // Load blank page to stop loading the current page
                // Navigate to success page in the app
                Navigator.pushReplacement(context,
  MaterialPageRoute(builder: (context) => PaymentSuccessfulPage()));
                return NavigationDecision.prevent;
              }
              return NavigationDecision.navigate;
            },
          ),
          if (_isLoading)
            Center(
              child: CircularProgressIndicator(
                color: Color.fromARGB(255, 16, 82, 136),
              ),
            ),
        ],
      ),
    );
  }
}
