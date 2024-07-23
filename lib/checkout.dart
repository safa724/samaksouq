import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ibeuty/pay.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckOut extends StatefulWidget {
  final int selectedAddressId;
  final double totalAmount;

  const CheckOut(
      {Key? key, required this.selectedAddressId, required this.totalAmount})
      : super(key: key);

  @override
  State<CheckOut> createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> {
  int ownerId = 0;

  late String userId;
  List<Map<String, dynamic>> _deliverySlots = [];
  List<Map<String, dynamic>> _selectedSlots = [];
  bool wantBox = false;
  bool showBoxOptions = false;
  String apiResponse = '';
  List<Box> boxes = [];
  int? selectedBoxId;
  int _selectedSlotIndex = -1;
  Map<String, dynamic>? _selectedTimeSlot;
  int? _selectedTimeSlotId;
  String? accessToken;
  String? _selectedDate;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchDeliverySlots();
    getUserIdFromSharedPreferences();
    getOwnerId();
  }

  Future<void> getOwnerId() async {
    int id = await getOwnerIdFromSharedPreferences();
    setState(() {
      ownerId = id;
    });
  }

  Future<int> getOwnerIdFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('ownerId') ?? 0;
  }

  Future<void> getUserIdFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userId') ?? '';
      accessToken = prefs.getString('accessToken') ?? '';
    });
  }

  Future<void> fetchDeliverySlots() async {
    final response =
        await http.get(Uri.parse('http://samaksouq.com/api/v2/deliveryslot'));

    if (response.statusCode == 200) {
      final slotsData = json.decode(response.body);

      if (slotsData['success']) {
        setState(() {
          _deliverySlots = [
            {
              'date': slotsData['today']['date'],
              'day': slotsData['today']['day'],
              'slots': slotsData['today']['slots']
            },
            {
              'date': slotsData['tomorrow']['date'],
              'day': slotsData['tomorrow']['day'],
              'slots': slotsData['tomorrow']['slots']
            },
          ];
        });
      }
    }
  }

  Future<void> callAPI() async {
    try {
      final response = await http.post(
        Uri.parse('https://www.samaksouq.com/api/v2/boxeslist'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'seller_id': '76'}),
      );

      if (response.statusCode == 200) {
        setState(() {
          final responseData = jsonDecode(response.body);
          final List<dynamic> dataList = responseData['data'];
          boxes = dataList.map((data) => Box.fromJson(data)).toList();
        });
      } else {
        print('Failed to fetch data: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'CheckOut',
          style: TextStyle(color: Color.fromARGB(255, 16, 82, 136)),
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Colors.black,
          ),
          onPressed: () {},
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            height: 100,
                            width: 470,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Color.fromARGB(255, 6, 85, 150)),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Container(
                                      height: 70,
                                      width: 100,
                                      child: Image.asset('images/card.png')),
                                  SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'MADA / VISA',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 5),
                                      Text('CheckOut with MADA / VISA'),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 13),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text("Delivery Info"),
                          ),
                        ),
                        SizedBox(height: 5),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                wantBox = !wantBox;
                                if (wantBox) {
                                  showBoxOptions = true;
                                  callAPI();
                                } else {
                                  showBoxOptions = false;
                                  selectedBoxId = null;
                                }
                              });
                            },
                            child: Container(
                              width: 470,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Color.fromARGB(255, 6, 85, 150),
                                    width: 2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(9.0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('Do you Want a Box?'),
                                          SizedBox(width: 70),
                                          Container(
                                            height: 20,
                                            width: 20,
                                            decoration: BoxDecoration(
                                              color: wantBox
                                                  ? Color.fromARGB(
                                                      255, 6, 85, 150)
                                                  : Colors.white,
                                              border: Border.all(
                                                  color: Colors.grey, width: 1),
                                            ),
                                            child: wantBox
                                                ? Icon(
                                                    Icons.check,
                                                    size: 16,
                                                    color: Colors.white,
                                                  )
                                                : null,
                                          )
                                        ],
                                      ),
                                    ),
                                    if (showBoxOptions)
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                  'please select a box type'),
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          for (var box in boxes)
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  selectedBoxId = box.id;
                                                });
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: selectedBoxId ==
                                                            box.id
                                                        ? Color.fromARGB(
                                                            255, 9, 82, 141)
                                                        : Color.fromARGB(
                                                            255, 85, 105, 122),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  height: 30,
                                                  width:
                                                      _calculateContainerWidth(
                                                          box),
                                                  margin: EdgeInsets.only(
                                                      bottom: 4),
                                                  child: Stack(
                                                    children: [
                                                      if (selectedBoxId !=
                                                          box.id)
                                                        Container(
                                                          height: 30,
                                                          width:
                                                              _calculateContainerWidth(
                                                                  box),
                                                        ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(3.0),
                                                        child: Center(
                                                          child: Text(
                                                            '${box.boxName} - SAR ${box.price}',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(height: 20),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text('Delivery Date'),
                                          ),
                                          SizedBox(height: 10),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                for (Widget container
                                                    in _buildDateContainers())
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        right: 8),
                                                    child: container,
                                                  ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 20),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text('Delivery Time'),
                                          ),
                                          SizedBox(height: 10),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                for (Widget container
                                                    in _buildTimeContainers())
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        right: 8),
                                                    child: container,
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Container(
                      height: 35,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 15, 78, 129),
                        borderRadius: BorderRadius.circular(7.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              'Total Amount',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Spacer(),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              'SAR ${widget.totalAmount.toStringAsFixed(2)}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    InkWell(
                      onTap: _navigateToDeliveryPage,
                      child: Container(
                        height: 50,
                        width: 400,
                        child: Center(
                          child: Text(
                            'PLACE MY ORDER',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Montserrat'),
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 2, 67, 119),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: CircularProgressIndicator(
                  color: Color.fromARGB(255, 34, 79, 116),
                ),
              ),
            ),
        ],
      ),
    );
  }

  List<Widget> _buildDateContainers() {
    return _deliverySlots.asMap().entries.map((entry) {
      final index = entry.key;
      final slot = entry.value;
      final bool isSelected = index == _selectedSlotIndex;

      return GestureDetector(
        onTap: () {
          setState(() {
            _selectedSlotIndex = index;
            _selectedSlots = List.from(slot['slots']);
            _selectedDate = slot['date'];
          });
        },
        child: Container(
          decoration: BoxDecoration(
            color: isSelected
                ? Color.fromARGB(255, 9, 82, 141)
                : Color.fromARGB(255, 85, 105, 122),
            borderRadius: BorderRadius.circular(5),
          ),
          height: 33,
          padding: EdgeInsets.all(8),
          margin: EdgeInsets.symmetric(vertical: 4),
          child: Text('${slot['date']},${slot['day']}',
              style: TextStyle(color: Colors.white)),
        ),
      );
    }).toList();
  }

  List<Widget> _buildTimeContainers() {
    return _selectedSlots.map((slot) {
      final bool isSelected = _selectedTimeSlotId == slot['id'];
      return GestureDetector(
        onTap: () {
          setState(() {
            _selectedTimeSlotId = slot['id'];
          });
        },
        child: Container(
          decoration: BoxDecoration(
            color: isSelected
                ? Color.fromARGB(255, 9, 82, 141)
                : Color.fromARGB(255, 85, 105, 122),
            borderRadius: BorderRadius.circular(5),
          ),
          padding: EdgeInsets.all(8),
          margin: EdgeInsets.symmetric(vertical: 4),
          child: Text('${slot['start_time']} - ${slot['end_time']}',
              style: TextStyle(color: Colors.white)),
        ),
      );
    }).toList();
  }

  void _navigateToDeliveryPage() async {
    setState(() {
      _isLoading = true;
    });
    if (_selectedTimeSlotId != null && _selectedDate != null) {
      final Map<String, dynamic> orderRequestBody = {
        "owner_id": ownerId,
        "user_id": userId,
        "payment_type": "Mada",
        "box_id": selectedBoxId,
        "delivery_slot_id": _selectedTimeSlotId,
        "delivery_date": _selectedDate
      };
      print(ownerId);
      print(userId);
      print(selectedBoxId);
      print(_selectedTimeSlotId);
      print(_selectedDate);
      print(accessToken);
      try {
        final http.Response orderResponse = await http.post(
          Uri.parse('https://samaksouq.com/api/v2/order/store'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken',
          },
          body: jsonEncode(orderRequestBody),
        );

        print('Order API Response: ${orderResponse.statusCode}');
        print('Order API Response Body: ${orderResponse.body}');

        if (orderResponse.statusCode == 200) {
          final Map<String, dynamic> paymentRequestBody = {
            "combined_order_id":
                jsonDecode(orderResponse.body)['combined_order_id'].toString(),
            "user_id": userId,
          };

          try {
            final http.Response paymentResponse = await http.post(
              Uri.parse('https://www.samaksouq.com/api/v2/order_payment'),
              headers: {
                'Authorization': 'Bearer $accessToken',
                'Content-Type': 'application/json',
              },
              body: jsonEncode(paymentRequestBody),
            );

            print('Payment API Response: ${paymentResponse.statusCode}');
            print('Payment API Response Body: ${paymentResponse.body}');

            if (paymentResponse.statusCode == 200) {
              final Map<String, dynamic> paymentData =
                  jsonDecode(paymentResponse.body);
              final String paymentUrl = paymentData['url'];

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PaymentScreen(paymentUrl: paymentUrl),
                ),
              );
            } else {
              print('Failed to make payment: ${paymentResponse.statusCode}');
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to make payment')));
            }
          } catch (paymentError) {
            print('Error making payment: $paymentError');
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('Error making payment')));
          }
        } else {
          print('Failed to create order: ${orderResponse.statusCode}');
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Failed to create order')));
        }
      } catch (orderError) {
        print('Error creating order: $orderError');
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error creating order')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select a delivery date and time')));
    }

    setState(() {
      _isLoading = false;
    });
  }
}

double _calculateContainerWidth(Box box) {
  final textLength = '${box.boxName} - SAR ${box.price}'.length;
  final textWidth = textLength * 8.0;
  return textWidth + 16.0;
}

class Box {
  final int id;
  final String boxName;
  final String boxSize;
  final String price;

  Box(
      {required this.id,
      required this.boxName,
      required this.boxSize,
      required this.price});

  factory Box.fromJson(Map<String, dynamic> json) {
    return Box(
      id: json['id'],
      boxName: json['box_name'],
      boxSize: json['box_size'],
      price: json['price'],
    );
  }
}
