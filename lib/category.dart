import 'package:flutter/material.dart';
import 'package:ibeuty/bar.dart';
import 'package:ibeuty/cart1.dart';
import 'package:ibeuty/drawer.dart';
import 'package:ibeuty/home.dart';
import 'package:ibeuty/userprofile.dart';

class CategoryScreen extends StatelessWidget {
  final List<Category> categories = [
    Category(name: 'Fishes & Seafood', imageAsset: '',)
    ];
   

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomBottomNavigationBar(
        
        currentIndex: 1,
        onTap: (int index) {
          // Handle navigation here
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Home()),
            );
          } else if (index == 3) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                   CartPage()
              ),
            );
          } else if (index == 4) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => UserProfileScreen()),
            );
            
          }
        },
        
      )
    ,
      
   drawer: AppDrawer(),
        appBar: AppBar(
        
          centerTitle: true,
          title: Text('Category',style: TextStyle(color:Color.fromARGB(255, 4, 74, 131)),),
        ),
     
body: (categories == null)
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return Container(
                  height: 70,
                   decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(color: Colors.grey),
                      ),
                      margin: EdgeInsets.all(8.0),
                  child: ListTile(
                    leading:Container(
                      color: Colors.transparent,
                      height: 40,
                      width: 40,
                      child: Image.asset(
                           'images/fish.png'
                          ),
                    ), 
                    title: Text(category.name),
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => ProductListScreen(categoryId: category.id),
                      //   ),
                      // );
                    },
                  ),
                );
              },
            ),
    );
    
  }
}




class Category {
  final String name;
  final String imageAsset;

  Category({required this.name, required this.imageAsset});
}
