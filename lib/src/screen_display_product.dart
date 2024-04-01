import 'package:flutter/material.dart';
import 'dart:convert';

class ResultsScreen extends StatelessWidget {

//Impact Colours
  final Color impactGrey = const Color(0xFFC9C8CA);
  final Color impactRed = const Color(0xFFF4333C);
   final Color impactBlack = const Color(0xFF040404);

  final Map<String, dynamic>? productDetails; // Parameter to hold the word

  //ResultsScreen({super.key});
  // Constructor to receive the word parameter
  ResultsScreen({Key? key, required String json})
    : productDetails = jsonDecode(json),
      super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: impactGrey,
        leading: IconButton(
        icon: const Icon(Icons.menu, color: Colors.black),
        onPressed: (){},
      ),
      actions: [
          IconButton(
            icon: const Icon(Icons.home, color: Colors.black), // Add the home button icon
            onPressed: () {
              // Add functionality for the home button here
            },
          ),
      ],
      ),
      body: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [


        //Product Name heading
         Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            productDetails!['name'],
            style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold, color: impactBlack),
          ),
        ),


        // Product image box
        Padding(
          padding: const EdgeInsets.all(16.0), // Adjust padding around the image
          child:
            SizedBox(
              width: 220, // Take up roughly a third of the screen
              height: 220, // Make it square
              child: Image.network(
              productDetails!['img'], // Replace with your image URL
              fit: BoxFit.cover, // Adjust image fit as needed
            ),
            ),
        ),

      //Manufacturer label
      Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 50.0, 45.0, 0.0), // Specify the padding
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: impactGrey,
                width: 1.0, // Adjust the width of the underline as needed
              ),
            ),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Manufacturer: "+ productDetails!['brand'],
              style: TextStyle(fontSize: 18,  color: impactBlack),
            ),
          ),
        ),
      ),
        
        
        //Price Label
        Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 0.0, 45.0, 16.0), // Specify the padding
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: impactGrey,
                width: 1.0, // Adjust the width of the underline as needed
              ),
            ),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Price: \$'+ productDetails!['price'],
              style: TextStyle(fontSize: 18,  color: impactBlack),
            ),
          ),
        ),
        ),
        
      ],
    ),
    );
  }
}