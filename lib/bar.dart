import 'package:flutter/material.dart';
import 'package:ibeuty/cartprovider.dart';
import 'package:provider/provider.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  CustomBottomNavigationBar({
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Stack(
      children: [
        BottomNavigationBar(
          currentIndex: currentIndex,
          backgroundColor: Colors.white,
          selectedItemColor: Color.fromARGB(255, 2, 67, 119),
          unselectedItemColor: Color.fromARGB(255, 172, 170, 170),
          type: BottomNavigationBarType.fixed,
          onTap: onTap,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu),
              label: 'Categories',
            ),
            BottomNavigationBarItem(
              icon: ClipOval(
                child: Image.asset(
                  'images/logo.png',
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Stack(
                children: [
                  Icon(Icons.shopping_cart),
                  if (cartProvider.cartItemCount > 0)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          cartProvider.cartItemCount.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
              label: 'Cart',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ],
    );
  }
}
