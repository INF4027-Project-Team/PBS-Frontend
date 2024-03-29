import 'package:flutter/material.dart';

class ResultsScreen extends StatelessWidget {

//Impact Colours
  final Color impactGrey = const Color(0xFFC9C8CA);
  final Color impactRed = const Color(0xFFF4333C);
  final Color impactBlack = const Color(0xFF040404);

  final String? code; // Parameter to hold the word

  // Constructor to receive the word parameter
  ResultsScreen({super.key, required this.code});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: impactGrey,
        leading: IconButton(
        icon: const Icon(Icons.menu),
        onPressed: (){},
      ),
      actions: [
          IconButton(
            icon: const Icon(Icons.home), // Add the home button icon
            onPressed: () {
              // Add functionality for the home button here
            },
          ),
      ],
      ),
      body: Center(
        child: Text(
          code as String,
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}