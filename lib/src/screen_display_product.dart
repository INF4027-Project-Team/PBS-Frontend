import 'package:flutter/material.dart';
import 'dart:convert';

class ResultsScreen extends StatelessWidget {

//Impact Colours
  final Color impactGrey = const Color(0xFFC9C8CA);
  final Color impactRed = const Color(0xFFF4333C);
   final Color impactBlack = const Color(0xFF040404);

    //Other interface colours
  Color softPurple = const Color(0xFFAA62B7);
  Color gloomyPurple = const Color(0xFF8A4EDD);

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
              width: 180, // Take up roughly a third of the screen
              height: 180, // Make it square
              child: Image.network(
              productDetails!['img'], // Replace with your image URL
              fit: BoxFit.cover, // Adjust image fit as needed
            ),
            ),
        ),

      //Manufacturer label
      Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 32.0, 45.0, 0.0), // Specify the padding
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
        
        
        //Cheapest Price Label
        Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 0.0, 45.0, 0.0), // Specify the padding
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
              'Lowest Price: \$'+ productDetails!['price'],
              style: TextStyle(fontSize: 18,  color: impactBlack),
            ),
          ),
        ),
        ),
        

        //Highest Commision Label
        Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 0.0, 45.0, 0.0), // Specify the padding
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
              'Highest Commision Rate: '+ productDetails!['rate']+"%",
              style: TextStyle(fontSize: 18,  color: impactBlack),
            ),
          ),
        ),
        ),


        //View Offers Button
        Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 32.0, 10.0, 0.0), // Specify the padding
        child: Container(
          padding: const EdgeInsets.all(6.0),
          width: double.infinity,
          //height: 60,
          decoration: BoxDecoration(
                  color: softPurple,
                  borderRadius: BorderRadius.circular(5.0), // Adjust the value to change the roundness
                ),
                child: TextButton(
                    onPressed: () async {
                        try {

                            } catch (e) {
                                print(e);
                            }
                    },
                
                child: const Text(
                    'View Offers',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
        ),
        ),

        
        //Favourates Button
        Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 16.0, 10.0, 0.0), // Specify the padding
        child: Container(
          padding: const EdgeInsets.all(6.0),
          width: double.infinity,
          //height: 60,
          decoration: BoxDecoration(
                  color: gloomyPurple,
                  borderRadius: BorderRadius.circular(5.0), // Adjust the value to change the roundness
                ),
                child: TextButton(
                    onPressed: () async {
                        try {

                            } catch (e) {
                                print(e);
                            }
                    },
                
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.star,
                      color: Colors.white,
                    ),
                    SizedBox(width: 8), // Add spacing between icon and text
                    Text(
                      'Add to Favorites',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                ),
        ),
        ),
        


      ],
    ),
    );
  }
}