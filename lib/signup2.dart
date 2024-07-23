
// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:ibeuty/login.dart';

// class SignUp extends StatefulWidget {
//   const SignUp({Key? key}) : super(key: key);

//   @override
//   State<SignUp> createState() => _SignUpState();
// }

// class _SignUpState extends State<SignUp> {
//   TextEditingController nameController = TextEditingController();
//   TextEditingController phoneController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();

//   Future<void> signUp() async {
//     final String apiUrl = 'https://samaksouq.com/api/v2/auth/signup';

//     Map<String, dynamic> data = {
//       "name": nameController.text,
//       "email_or_phone": phoneController.text,
//       "password": passwordController.text,
//       "register_by": "email_or_phone"
//     };

//     String requestBody = json.encode(data);

//     Map<String, String> headers = {
//       "Content-Type": "application/json",
//       "X-Requested-With": "XMLHttpRequest"
//     };

//     try {
//       http.Response response = await http.post(Uri.parse(apiUrl),
//           headers: headers, body: requestBody);

//       if (response.statusCode == 201) {
//         print('Signup successful');
//         print(requestBody);
//         // Signup successful, show scaffold message
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Successfully registered! Please proceed to login.'),
//           ),
//         );
//         // Navigate to login page
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => Login(initialPage: 'home')),
//         );
//       } else {
//         print('Request failed with status: ${response.statusCode}');
//         // Handle other status codes here if needed
//       }
//     } catch (error) {
//       print('Error sending request: $error');
//       // Handle error, e.g., show error message to the user
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               SizedBox(height: 150),
//               ClipOval(
//                 child: Image.asset(
//                   'images/logo.png',
//                   width: 80,
//                   height: 80,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//               SizedBox(height: 15),
//               Text(
//                 'Join Samaksouq',
//                 style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     color: Color.fromARGB(255, 3, 73, 129),
//                     fontSize: 20),
//               ),
//               SizedBox(height: 10),
//               Column(children: [
//                 Align(
//                     alignment: Alignment.centerLeft,
//                     child: Text("           Name",
//                         style: TextStyle(
//                             color: const Color.fromARGB(255, 8, 78, 134),
//                             fontWeight: FontWeight.w700))),
//                 Container(
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Colors.grey),
//                     borderRadius: BorderRadius.circular(5.0),
//                   ),
//                   width: 300,
//                   height: 45,
//                   // Adjust the width as needed
//                   child: Row(
//                     children: [
//                       Expanded(
//                         child: TextField(
//                           controller: nameController,
//                           decoration: InputDecoration(
//                             border: InputBorder.none,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 10),
//                 Align(
//                     alignment: Alignment.centerLeft,
//                     child: Text("           phone",
//                         style: TextStyle(
//                             color: const Color.fromARGB(255, 8, 78, 134),
//                             fontWeight: FontWeight.w700))),
//                 Container(
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Colors.grey),
//                     borderRadius: BorderRadius.circular(5.0),
//                   ),
//                   width: 300,
//                   // Adjust the width as needed
//                   child: Row(
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Text("+966", style: TextStyle(color: Colors.black)),
//                       ),
//                       VerticalDivider(
//                         color: Colors.grey,
//                         thickness: 1.0,
//                         width: 1.0,
//                       ),
//                       Expanded(
//                         child: TextField(
//                           controller: phoneController,
//                           keyboardType: TextInputType.phone,
//                           decoration: InputDecoration(
//                             border: InputBorder.none,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 10),
//                 Align(
//                   alignment: Alignment.centerLeft,
//                   child: Text(
//                     "           Password",
//                     style: TextStyle(
//                       color: const Color.fromARGB(255, 8, 78, 134),
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),
//                 ),
//                 Container(
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Colors.grey),
//                     borderRadius: BorderRadius.circular(5.0),
//                   ),
//                   width: 300,
//                   child: Row(
//                     children: [
//                       Expanded(
//                         child: TextField(
//                           controller: passwordController,
//                           obscureText: true,
//                           decoration: InputDecoration(
//                             border: InputBorder.none,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(
//                   height: 40,
//                 ),
//                 InkWell(
//                   onTap: signUp,
//                   child: Container(
//                       height: 50,
//                       decoration: BoxDecoration(
//                         color: Color.fromARGB(255, 21, 81, 129),
//                         borderRadius: BorderRadius.circular(15.0),
//                       ),
//                       width: 300, // Adjust the width as needed
//                       child: Center(
//                           child: Text(
//                         'Sign Up',
//                         style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                             fontSize: 16),
//                       ))),
//                 ),
//                 SizedBox(height: 15),
//                 Text('              Already have an Account ?',
//                     style: TextStyle(color: Colors.grey)),
//                 InkWell(
//                   onTap: () {
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => Login(initialPage: 'home')));
//                   },
//                   child: Container(
//                       height: 50,
//                       decoration: BoxDecoration(
//                         color: Color.fromARGB(255, 21, 81, 129),
//                         borderRadius: BorderRadius.circular(15.0),
//                       ),
//                       width: 300, // Adjust the width as needed
//                       child: Center(
//                           child: Text('Log in',
//                               style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.white,
//                                   fontSize: 16))))),
//               ])
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
