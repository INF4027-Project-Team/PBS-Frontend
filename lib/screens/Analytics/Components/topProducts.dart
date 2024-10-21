
import 'package:flutter/material.dart';


class RankingCard extends StatelessWidget {
  final List<String>? items;
  final String heading;

  const RankingCard({super.key, required this.items, required this.heading});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: SizedBox(
        height: 200,
        child: Card(
          margin: const EdgeInsets.fromLTRB(30, 10, 30, 10),
          color: const Color(0xFFF5F6F9),
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Heading text
                Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Color(0xFFDDDEE1), // Bottom border color
                      ),
                    ),
                  ),
                  alignment: Alignment.topLeft,
                  child: Row(
                    mainAxisSize: MainAxisSize.min, // Ensure the row takes up only as much space as needed
                    children: [
                      const Icon(
                        Icons.emoji_events_outlined, // Choose the icon you want
                        color: Colors.grey,
                        size: 18,
                      ),
                      SizedBox(width: 4), // Add space between the icon and text
                      Text(
                        heading,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),

                // Space between title and content
                SizedBox(height: 7),

                // Row of 5 containers with gradient colors and images
               Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: List.generate(5, (index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 2),
                          alignment: Alignment.topLeft,
                          child: Text(
                            '${index + 1}. ${items?[index]}',
                            maxLines: 1,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        );
                      }),
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
