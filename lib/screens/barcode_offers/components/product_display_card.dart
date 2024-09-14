import 'dart:ffi';

import 'package:flutter/material.dart';
import '../../product_details/product_details_screen.dart';
import '../../../objects/Product.dart'; 

class ProductDisplayCard extends StatelessWidget {
  final Product item;
  final List<Product> specialOffers;

  const ProductDisplayCard({super.key, required this.item, required this.specialOffers});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DetailsScreen(productDetails: item)), 
        );
      },

      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        
        child: SizedBox(
          height: 130, 
          
          child: Card(
            margin: const EdgeInsets.all(8),
            color: const Color(0xFFF5F6F9),
            elevation: 0,
            
            child: Padding(
              padding: const EdgeInsets.all(10),
              
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  
                  // Top row displaying network image and Best Offer symbol
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // Network image
                      Expanded(
                        child: 
                          setLogoPath(),
                      ),

                      

                      // Best Offer container
                      Container(
                        width: 100, // Set a fixed width for the container
                        child: item == specialOffers[0]
                            ? Container(
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child:  const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Best Offer',
                                      style: TextStyle(fontSize: 12, color: Colors.white),
                                    ),
                                    SizedBox(width: 8), // Add some spacing between the text and the icon
                                    Icon(
                                      Icons.local_offer, // You can use Icons.star if you prefer
                                      size: 14, // Adjust the size of the icon as needed
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              )
                            
                            : item == specialOffers[2] // Check if product is best commission
                            ? Container(
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.blue[400],
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Best Commision',
                                      style: TextStyle(fontSize: 12, color: Colors.white),
                                    ),
                                    SizedBox(width: 8), // Add some spacing between the text and the icon
                                    Icon(
                                      Icons.trending_up, // You can use Icons.star if you prefer
                                      size: 14, // Adjust the size of the icon as needed
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              )

                            : item == specialOffers[1] // Check if product is best price
                            ? Container(
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Best Price',
                                      style: TextStyle(fontSize: 12, color: Colors.white),
                                    ),
                                    SizedBox(width: 8), // Add some spacing between the text and the icon
                                    Icon(
                                      Icons.attach_money, // You can use Icons.star if you prefer
                                      size: 14, // Adjust the size of the icon as needed
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              )

                            
                            : Container(), // Empty container when not "Best Offer"
                      ),
                    ],
                  ),
                  SizedBox(height: 10), // Space between top row and text

                  // Column for price and commission on sale
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Price (${item.currency}): ${item.price.toStringAsFixed(2)}',
                      ),
                      SizedBox(height: 5), // Adjust spacing between texts if needed
                      Text(
                        'Commission On Sale (${item.currency}): ${item.commission}% (${(item.price * (item.commission / 100)).toStringAsFixed(2)})',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  //Gets the image path for the given network
  Widget setLogoPath() {
    Widget logoPath = Image.network(item.logoPath,
                          height: 35,
                          alignment: Alignment.centerLeft, );
    if (item.network == "eBay") {
      logoPath = Image.asset('assets/images/ebay_logo.png',
                          height: 35,
                          alignment: Alignment.centerLeft, );
    }
    
    return logoPath;
  }
}
