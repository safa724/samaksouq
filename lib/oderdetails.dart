import 'package:flutter/material.dart';

class OrderDetails extends StatefulWidget {
  const OrderDetails({Key? key}) : super(key: key);

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text('Purchase History'),
      ),
      body: ListView.builder(
        itemCount: 2, // Number of items in the list
        itemBuilder: (BuildContext context, int index) {
          // Return a ListTile for each item
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.black),
             
            ),
            child: ListTile(
              title: Text('Item '), // Custom title for the item
              subtitle: Text('Subtitle $index'), // Custom subtitle for the item
              onTap: () {
                // Action to perform when the item is tapped
                print('Tapped on Item $index');
              },
            ),
          );
        },
      ),
    );
  }
}
