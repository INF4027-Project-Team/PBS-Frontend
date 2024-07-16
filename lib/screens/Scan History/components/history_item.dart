import 'package:flutter/material.dart';
import '../../product_details/product_details_screen.dart';
import '/objects/product.dart'; 

class HistoryItemCard extends StatelessWidget {
  final Product item;

  const HistoryItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        //Navigator.pushNamed(context, DetailsScreen.routeName);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DetailsScreen(productDetails: item)), 
        );
      },

      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        
        child: SizedBox(
          height: 75, 
          
          child: Card(
            margin: const EdgeInsets.all(8),
            color: const Color(0xFFF5F6F9),
            elevation: 0,
            
            child: Padding(
              padding: const EdgeInsets.all(10),
              
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Network image
                  Image.network(
                    item.imagePath,
                    height: 50,
                  ),

                  SizedBox(width: 10), // Space between image and text

                  // Column for title and other details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          item.title,
                          maxLines: 2,
                          style: const TextStyle(
                            fontSize: 11,
                            
                            //fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5), // Space between title and other text
                        // Additional text/details can be added here
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
