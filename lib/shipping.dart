import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ibeuty/addresservice.dart';
import 'package:ibeuty/checkout.dart';
import 'package:ibeuty/login.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/addressmodel.dart';

class AddressPage extends StatefulWidget {
  final double totalAmount;

  const AddressPage({super.key, required this.totalAmount});

  @override
  _AddressPageState createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late List<Address> _addresses = [];
  late AddressService _addressService;
  bool isLoggedIn = false;
  String userPhone = '';
  int? _selectedAddressId;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
    _loadAddresses();
  }

  Future<void> _loadAddresses() async {
    try {
      setState(() {
        _isLoading = true;
      });
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken') ?? '';
      _addressService = AddressService(accessToken);
      final addresses = await _addressService.getUserAddresses();
      setState(() {
        _addresses = addresses;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading addresses: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _selectAddress(int addressId) {
    setState(() {
      _selectedAddressId = addressId;
    });
  }

  void _proceedToCheckout() {
    if (_selectedAddressId != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CheckOut(
            selectedAddressId: _selectedAddressId!,
            totalAmount: widget.totalAmount,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please select an address',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _addAddress() async {
    final address = _addressController.text;
    final phone = _phoneController.text;
    try {
      await _addressService.addUserAddress(address, phone);
      _addressController.clear();
      _phoneController.clear();

      await _loadAddresses();
    } catch (e) {
      print('Error adding address: $e');
    }
  }

  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
      if (isLoggedIn) {
        userPhone = prefs.getString('userPhone') ?? '';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Addresses',
          style: TextStyle(color: Color.fromARGB(255, 4, 48, 85)),
        ),
      ),
      body: _isLoading ? _buildLoadingWidget() : _buildAddressBody(),
    );
  }

  Widget _buildLoadingWidget() {
    return Center(
      child: CircularProgressIndicator(
        color: Color.fromARGB(255, 4, 48, 85),
      ),
    );
  }

  Widget _buildAddressBody() {
    return Padding(
      padding: EdgeInsets.all(12),
      child: Column(
        children: [
          SizedBox(height: 10),
          Expanded(
            child: isLoggedIn ? buildAddressList() : buildLoginPrompt(),
          ),
          InkWell(
            onTap: () {
              if (isLoggedIn) {
                _showAddAddressDialog();
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Login(initialPage: 'profile')),
                );
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10)),
                child: Center(child: Text("+ Add New Address")),
              ),
            ),
          ),
          InkWell(
            onTap: _proceedToCheckout,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                    color: Color.fromARGB(255, 5, 61, 107)),
                child: Center(
                    child: Text(
                  "PROCEED TO CHECKOUT",
                  style: TextStyle(color: Colors.white),
                )),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildAddressList() {
    return ListView.builder(
      itemCount: _addresses.length,
      itemBuilder: (context, index) {
        final address = _addresses[index];
        return GestureDetector(
          onTap: () {
            _selectAddress(address.id);
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: _selectedAddressId == address.id
                    ? Color.fromARGB(255, 4, 44, 77)
                    : Colors.grey,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            margin: EdgeInsets.all(10),
            child: ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Address",
                          style: TextStyle(color: Colors.grey, fontSize: 13)),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              address.address!,
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () => _editAddress(index),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.delete_forever_rounded,
                              color: Colors.red,
                            ),
                            onPressed: () => _deleteAddress(index),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Phone",
                          style: TextStyle(color: Colors.grey, fontSize: 13)),
                      SizedBox(width: 10),
                      Text(
                        address.phone,
                        style: TextStyle(color: Colors.black, fontSize: 13),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildLoginPrompt() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Please login to continue',
          style: TextStyle(fontSize: 18),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Login(initialPage: 'address')),
            );
          },
          child: Text('Login'),
        ),
      ],
    );
  }

  void _showAddAddressDialog() {
    _phoneController.text = userPhone;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          children: [
            Container(
              height: 400.0,
              width: 350,
              padding: EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      _buildTextFieldWithBorder('Name', nameController),
                      SizedBox(height: 10),
                      _buildTextFieldWithBorder('Address', _addressController,
                          height: 100.0),
                      SizedBox(height: 10),
                      _buildTextFieldWithBorder(
                          'Phone Number', _phoneController),
                    ],
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 35,
                  width: 70,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 3, 88, 158),
                      borderRadius: BorderRadius.circular(10.0)),
                  height: 35,
                  width: 70,
                  child: TextButton(
                    onPressed: () {
                      _addAddress();
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Add',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextFieldWithBorder(
      String label, TextEditingController controller,
      {double height = 50.0}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (label == 'Address')
                InkWell(
                  onTap: () async {
                    await _requestLocationPermission();
                    _fetchCurrentLocation();
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Colors.blue,
                      ),
                      Text(
                        'Get Address',
                        style: TextStyle(color: Colors.blue),
                      )
                    ],
                  ),
                ),
            ],
          ),
        ),
        Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                height: height,
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                  maxLines: label == 'Address' ? null : 1,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _editAddress(int index) {}

  void _deleteAddress(int index) {
    setState(() {});
  }

  TextEditingController nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  Future<void> _requestLocationPermission() async {
    PermissionStatus status = await Permission.location.request();
    if (status.isDenied) {
      print('Location permission is denied by the user.');
    }
  }

  Future<void> _fetchCurrentLocation() async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.blue,
            ),
          );
        },
      );

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      Navigator.pop(context);

      if (placemarks.isNotEmpty) {
        Placemark currentPlacemark = placemarks.first;
        String currentLocation =
            "${currentPlacemark.thoroughfare},${currentPlacemark.street},${currentPlacemark.locality}, ${currentPlacemark.administrativeArea}, ${currentPlacemark.country},${currentPlacemark.postalCode}";

        setState(() {
          _addressController.text = currentLocation;
        });
      }
    } catch (e) {
      Navigator.pop(context);
      print("Error fetching location: $e");
    }
  }
}
