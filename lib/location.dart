import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LocationScreen extends StatefulWidget {
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  List<Map<String, dynamic>> locationList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchLocations();
  }

  Future<void> fetchLocations() async {
    final response = await http
        .get(Uri.parse('http://samaksouq.com/api/v2/seller_location'));
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      setState(() {
        locationList = List<Map<String, dynamic>>.from(
            responseData['location'].map((location) => {
                  'id': location['id'],
                  'name': location['name'],
                }));
        isLoading = false;
      });
    } else {
      print('Failed to load locations');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose Your Location'),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Color.fromARGB(255, 3, 59, 105),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(12.0),
              child: ListView.builder(
                itemCount: locationList.length,
                itemBuilder: (context, index) {
                  final location = locationList[index];
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7.0),
                      border: Border.all(
                        color: Color.fromARGB(255, 3, 59, 105),
                      ),
                    ),
                    margin: EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: Icon(Icons.location_pin,
                          color: Color.fromARGB(255, 1, 39, 70)),
                      title: Text(location['name'],
                          style: TextStyle(fontSize: 15)),
                      onTap: () {
                        Navigator.pop(context,
                            {'id': location['id'], 'name': location['name']});
                      },
                      trailing: Icon(Icons.arrow_forward_ios_rounded,
                          color: Color.fromARGB(255, 1, 39, 70)),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
