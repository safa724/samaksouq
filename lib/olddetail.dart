
// import 'package:flutter/material.dart';
// import 'package:ibeuty/apiservice.dart';
// import 'package:ibeuty/cart1.dart';
// import 'package:ibeuty/cartprovider.dart';
// import 'package:ibeuty/home.dart';
// import 'package:ibeuty/models/productmodel.dart';
// import 'package:provider/provider.dart';

// class ProductDetailScreen extends StatefulWidget {
//   final List<Product> products;
//   final int selectedProductIndex;

//   const ProductDetailScreen({
//     Key? key,
//     required this.products,
//     required this.selectedProductIndex,
//   }) : super(key: key);

//   @override
//   _ProductDetailScreenState createState() => _ProductDetailScreenState();
// }

// class _ProductDetailScreenState extends State<ProductDetailScreen> {
//   int quantity = 1; // Initial quantity
//   bool isExpanded = false; // To manage whether the description is expanded or not
//   ApiService apiService = ApiService();
//  @override
//   void initState() {
//     super.initState();
//     apiService.fetchFeaturedProducts(context); // Call the method to fetch featured products when the widget is initialized
//     print('Featured Products: ${apiService.featuredProducts.length}');
//   }
//   void toggleExpand() {
//     setState(() {
//       isExpanded = !isExpanded;
//     });
//   }

//   void _addToCart(BuildContext context) async {
//     try {
//       // Get the selected product
//       Product selectedProduct = widget.products[widget.selectedProductIndex];

//       // Create a new instance of the product to add to the cart
//       Product productToAdd = Product(
//         id: selectedProduct.id,
//         name: selectedProduct.name,
//         thumbnailImage: selectedProduct.thumbnailImage,
//         hasDiscount: selectedProduct.hasDiscount,
//         discount: selectedProduct.discount,
//         strokedPrice: selectedProduct.strokedPrice,
//         mainPrice: selectedProduct.mainPrice,
//         rating: selectedProduct.rating,
//         sales: selectedProduct.sales,
//         quantity: quantity,
//       );

//       // Add the product to the cart using the CartProvider
//       context.read<CartProvider>().addToCart(productToAdd);

//       // Show a SnackBar with the message "Adding to Cart..."
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Row(
//             children: [
//               CircularProgressIndicator(),
//               SizedBox(width: 16.0),
//               Text('Adding to Cart...'),
//             ],
//           ),
//           duration: Duration(seconds: 2),
//         ),
//       );

//       // Hide the current SnackBar
//       ScaffoldMessenger.of(context).hideCurrentSnackBar();

//       // Show a new SnackBar with the message "Added to Cart"
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text('Added to Cart',),
//               TextButton(
//                 onPressed: () {
//                   // Navigate to the CartPage
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => CartPage(cartItems: context.read<CartProvider>().cartItems),
//                     ),
//                   );
//                 },
//                 child: Text(
//                   'Go to Cart',
//                   style: TextStyle(color: Colors.blue,fontFamily: 'Montserrat'),
//                 ),
//               ),
//             ],
//           ),
//           duration: Duration(seconds: 2),
//         ),
//       );
//     } catch (error) {
//       print('Error during addToCart: $error');
//       // Handle the error and show an appropriate message to the user
//       ScaffoldMessenger.of(context).hideCurrentSnackBar();
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Failed to add to Cart. Please try again.'),
//           duration: Duration(seconds: 2),
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Access the selected product from the products list
//     Product product = widget.products[widget.selectedProductIndex];

//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         centerTitle: true,
//         title: Text('Product',style: TextStyle(color: const Color.fromARGB(255, 5, 51, 88)),),
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.share),
//             onPressed: () {
//               // Add your logic for sharing the product
//             },
//           ),
//         ],
//       ),
//       body: ListView(
//         padding: EdgeInsets.all(16.0),
//         children: [
//           Container(
//             width: MediaQuery.of(context).size.width,
//             height: 250,
//             decoration: BoxDecoration(
//               image: DecorationImage(
//                 image: NetworkImage(product.thumbnailImage),
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//           SizedBox(height: 16.0),
//           Row(
//             children: [
//               Flexible(
//                 child: Text(
                  
//                   product.name,
//                   textAlign: TextAlign.left,
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.black,
//                   ),
//                 ),
//               ),
//               SizedBox(width: 100),
//             ],
//           ),
//           SizedBox(height: 30),
//           RichText(
//             text: TextSpan(
//               children: [
//                 TextSpan(
//                   text: '  Price: ',
//                   style: TextStyle(
//                     color: Colors.black,
//                   ),
//                 ),
//                 TextSpan(
//                   text: '${product.mainPrice}',
//                   style: TextStyle(
//                     color: const Color.fromARGB(255, 10, 74, 126),
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(height: 40.0),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text("  Quantity:  "),
//               Container(
//                 margin: EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(15),
//                 ),
//                 child: Container(
//                   width: 140,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(30),
//                     border: Border.all(color: Colors.grey),
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       IconButton(
//                         icon: Icon(Icons.remove),
//                         onPressed: () {
//                           updateQuantity(-1);
//                         },
//                       ),
//                       Text('$quantity',style: TextStyle(color: Color.fromARGB(255, 6, 67, 117)),),
//                       IconButton(
//                         icon: Icon(Icons.add),
//                         onPressed: () {
//                           updateQuantity(1);
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 40.0),
//           Text(
//             '  Description: Product description goes here',
//             style: TextStyle(fontSize: 15.0),
//             maxLines: isExpanded ? null : 2,
//             overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
//           ),
//           SizedBox(height: 8),
//           Align(
//             alignment: Alignment.centerRight,
//             child: InkWell(
//               onTap: toggleExpand,
//               child: Text(
//                 isExpanded ? 'View Less' : 'View More',
//                 style: TextStyle(color: Colors.black),
//               ),
//             ),
//           ),
//           SizedBox(height: 20),
//           Text('Products you may like',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),),
//            SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       child: Row(
//         children: apiService.featuredProducts.map((featuredProduct) {
//           return SizedBox(
//             width: 150,
//             child: ProductCard(product: featuredProduct, products: apiService.featuredProducts),
//           );
//         }).toList(),
//       ),
//     ),
//   ],
// ),
      
//       bottomNavigationBar: Container(
//         height: 60,
//         color: Color.fromARGB(255, 188, 214, 235),
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               InkWell(
//                 onTap: () {
//                   _addToCart(context);
//                 },
//                 child: Container(
//                   height: 45,
//                   width: 160,
//                   child: Center(child: Text('Add to Cart', style: TextStyle(color: Colors.white, fontSize: 17),)),
//                   color: Color.fromARGB(255, 15, 158, 75),
//                 ),
//               ),
//               Container(
//                 height: 45,
//                 child: Center(child: Text('Buy Now', style: TextStyle(color: Colors.white, fontSize: 17),)),
//                 width: 160,
//                 color: Color.fromARGB(255, 17, 61, 97),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void updateQuantity(int change) {
//     setState(() {
//       quantity += change;
//       if (quantity < 1) {
//         quantity = 1; // Ensure quantity is always at least 1
//       }
//     });
//   }
// }
