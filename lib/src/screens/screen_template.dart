import 'package:flutter/material.dart';

class BlankScreenTemplate extends StatelessWidget {

  //Impact Colours
  final Color impactGrey = Color(0xFFC9C8CA);
  final Color impactRed = Color(0xFFF4333C);
   Color impactBlack = Color(0xFF040404);

  BlankScreenTemplate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background color to white
      appBar: AppBar(
        backgroundColor: impactGrey,
        leading: IconButton(
        icon: Icon(Icons.menu, color: Colors.black),
        onPressed: (){},
      ),
      actions: [
          IconButton(
            icon: Icon(Icons.home, color: Colors.black), // Add the home button icon
            onPressed: () {
              // Add functionality for the home button here
            },
          ),
      ],
      ),
      body: const SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Add your additional items here
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Your Content Goes Here',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            // Add more widgets as needed
          ],
        ),
      ),
    );
  }
}