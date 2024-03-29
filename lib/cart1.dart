import 'package:flutter/material.dart';
import 'package:ibeuty/bar.dart';
import 'package:ibeuty/cartprovider.dart';
import 'package:ibeuty/category.dart';
import 'package:ibeuty/drawer.dart';
import 'package:ibeuty/home.dart';
import 'package:ibeuty/shipping.dart';
import 'package:ibeuty/userprofile.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
 


  bool isLoggedIn = false;
  double totalAmount = 0.0;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<CartProvider>(context, listen: false).fetchCartItems();
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        
        centerTitle: true,
        title: Text(
          'Shopping Cart',
          style: TextStyle(
            color: Color.fromARGB(255, 1, 69, 124),
          ),
        ),
      ),
      body: isLoggedIn ? buildCartItemsList(context) : buildLoginPrompt(),
      bottomNavigationBar: Consumer<CartProvider>(
        builder: (context, cartProvider, _) {
          
          return CustomBottomNavigationBar(
  currentIndex: 3,
  
  onTap: (int index) {
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => CategoryScreen()),
      );
    } else if (index == 4) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => UserProfileScreen()),
      );
    }
  },
);
        }
      )
    );
  }
int calculateCartItemCount(List<dynamic> cartItems) {
    Set<String> itemIds = Set();
    for (var item in cartItems) {
      var cartItem = item['cart_items'][0];
      itemIds.add(cartItem['id']);
    }
    return itemIds.length;
  }
  Widget buildCartItemsList(BuildContext context) {
    
    
    return Consumer<CartProvider>(
      builder: (context, cartProvider, _) {
        List<dynamic> cartItems = cartProvider.cartItems;

        if (cartItems.isEmpty) {
          return Center(
            child: Text('Cart is empty'),
          );
        }
        totalAmount = 0.0;
for (var item in cartItems) {
    var cartItem = item['cart_items'][0];
    double price = cartItem['price'] ?? 0.0;
    int quantity = cartItem['quantity'] ?? 0;
    totalAmount += price * quantity;
  }
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  var cartItem = cartItems[index]['cart_items'][0];
                  return buildCartItemCard(context, cartItem, index);
                },
              ),
            ),
             Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 35,
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 211, 203, 203),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  'Total Amount',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.black,
                  ),
                ),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  'SAR ${totalAmount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 15, 78, 129),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      SizedBox(height: 5),
      Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          children: [
            Expanded(
              // Expanded widget added here
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
                  color: const Color.fromARGB(255, 185, 207, 224),
                ),
                child: Center(child: Text("UPDATE CART")),
              ),
            ),
            Expanded(
              // Expanded widget added here
              child: InkWell(
                onTap: cartItems.isNotEmpty
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddressPage(totalAmount: totalAmount),
                          ),
                        );
                      }
                    : () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Cart is Empty"),
                              content: Text("Please add items to your cart."),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("OK"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                    color: Color.fromARGB(255, 6, 53, 88),
                  ),
                  child: Center(
                    child: Text(
                      "PROCEED TO SHIPPING",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      )
          ],
        );
      },
    );
  }

  Widget buildLoginPrompt() {
    return Center(
      child: Text(
        'Please login to see cart items',
        style: TextStyle(fontSize: 18.0),
      ),
    );
  }

Widget buildCartItemCard(BuildContext context, dynamic cartItem, int index) {
  return Padding(
    padding: const EdgeInsets.all(5.0),
    child: Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.grey),
          ),
          margin: EdgeInsets.all(8.0),
          child: ListTile(
            contentPadding: EdgeInsets.all(16.0),
            leading: Image.network(
              cartItem['product_thumbnail_image'] ?? '',
              width: 50.0,
              height: 50.0,
            ),
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 200,
                        child: Text(
                          cartItem['product_name'] ?? '',
                          style: TextStyle(fontSize: 12),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 16), // Adjust as needed
              ],
            ),
            subtitle: Row(
              children: [
                Text(
                  ' ${'${cartItem['currency_symbol'] ?? ''} ${cartItem['price'] ?? ''}'}',
                  style: TextStyle(
                    color: const Color.fromARGB(255, 12, 81, 138),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                SizedBox(width: 80),
                Expanded(
                  child: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      // Remove item from cart using CartProvider
                      Provider.of<CartProvider>(context, listen: false)
                          .removeItemFromCart(cartItem['id'].toString(), index);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 12,
          right: 12,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: (){
                     Provider.of<CartProvider>(context, listen: false)
                            .updateCartItemQuantity(cartItem['id'].toString(), cartItem['quantity'] + 1);
                  },
                  child: Container(
                    height: 25,
                    width: 25,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle, // Defines the shape as a circle
                      border: Border.all(color: Colors.grey)
                    ),
                    child: Icon(Icons.add,size: 15, color: Color.fromARGB(255, 6, 53, 88),)
                  ),
                ),
                SizedBox(height: 5,),
                Text('${cartItem['quantity'] ?? ''}',style: TextStyle(fontSize: 18, color: Color.fromARGB(255, 6, 53, 88),),),
              SizedBox(height: 5,),
                InkWell(
                  onTap: (){
                    if (cartItem['quantity'] > 1) {
                        // Decrease quantity using CartProvider
                        Provider.of<CartProvider>(context, listen: false)
                            .updateCartItemQuantity(cartItem['id'].toString(), cartItem['quantity'] - 1);
                      }
                  },
                  child: Container(
                     height: 25,
                      width: 25,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle, // Defines the shape as a circle
                        border: Border.all(color: Colors.grey)
                      ),
                      child: Icon(Icons.remove,size: 15, color: Color.fromARGB(255, 6, 53, 88),)
                    
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}





  String _truncateProductName(String productName) {
    const int maxNameLength = 20;
    if (productName.length > maxNameLength) {
      return '${productName.substring(0, maxNameLength)}...';
    }
    return productName;
  }
}