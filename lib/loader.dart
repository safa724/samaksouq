import 'dart:ui';

import 'package:flutter/material.dart';

class QuantityChangeLoader extends StatelessWidget {
  final bool isLoading;

  QuantityChangeLoader({required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Stack(
            children: [
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                ),
              ),
              Center(
                child: CircularProgressIndicator(),
              ),
            ],
          )
        : SizedBox.shrink();
  }
}
