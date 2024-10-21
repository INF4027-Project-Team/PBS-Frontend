import 'package:flutter/material.dart';

class CounterCard extends StatelessWidget {
  final String? count;
  final String heading;
  final IconData iconImg;

  const CounterCard({
    super.key,
    required this.count,
    required this.heading,
    required this.iconImg,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: SizedBox(
        height: 145,
        width: 170,
        child: Card(
          margin: const EdgeInsets.all(4),
          color: const Color(0xFFF5F6F9),
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Heading text
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey.shade300, // Bottom border color
                      ),
                    ),
                  ),
                  alignment: Alignment.topLeft,
                  child: Row(
                    mainAxisSize: MainAxisSize.min, // Ensure the row takes up only as much space as needed
                    children: [
                      // Icon next to title
                      Icon(
                        iconImg, // Choose the icon you want
                        color: Colors.grey,
                        size: 18,
                      ),
                      const SizedBox(width: 4), // Add space between the icon and text
                      // Text heading
                      Text(
                        heading,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                // Space between title and content
                const SizedBox(height: 7),
                // Row of 5 containers with gradient colors and images
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                    child: Container(
                      padding: const EdgeInsets.all(2), // Space around the text inside the box
                      
                      decoration: BoxDecoration(
                        color: const Color(0xFFDDDEE1),
                        borderRadius: BorderRadius.circular(8), // Rounded corners of the box
                      ),
                      alignment: Alignment.center, // Or any other color for the background
                      child: Text(
                        count!,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          color: Colors.black,
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
    );
  }
}
