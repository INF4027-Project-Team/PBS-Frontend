
import 'package:flutter/material.dart';
import 'package:shop_app/screens/Dashboard/components/special_offers_card.dart';
import '../../product_details/product_details_screen.dart';
import '../../../objects/Product.dart'; 

class FeaturedOfferCard extends StatelessWidget {
  final Product item;
  final String? caption;
  const FeaturedOfferCard({super.key, required this.item, required this.caption});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DetailsScreen(productDetails: item)), 
        );
      },
        
      child: SizedBox(
        height: 225,

        child: Card(
          margin: const EdgeInsets.all(8),
          color: const Color(0xFFF5F6F9),
          elevation: 0,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.red, // Red border color
                width: 2, // Border thickness
              ),
              borderRadius: BorderRadius.circular(6), // Optional: match the card's rounded corners
            ),

            child: Padding(
            padding: const EdgeInsets.all(20),
            
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[

                // Top row displaying "Recommended Offer" and network image
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // "Recommended Offer" Text
                         Expanded(
                          child: Container(
                            padding: EdgeInsets.all(3), // Space around the text inside the box
                            decoration: BoxDecoration(
                              color: Color(0xFFF4333C), // Background color of the box
                              borderRadius: BorderRadius.circular(8), // Rounded corners of the box
                            ),
                            alignment: Alignment.center,

                            child: const Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                
                                //Heading text
                                Text(
                                      'Recommended Offer',
                                      style: TextStyle(
                                      fontSize: 19,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                //Space before text
                                SizedBox(width: 4),

                                //Star symbol next to offer
                                Icon(
                                  Icons.local_fire_department,  // Choose the icon you want
                                  color: Colors.white,  // Set icon color
                                  size: 23.5,  // Set icon size
                                    ),
                                
                                

                                
                              ],
                            ),
                          ),
                        ),
                        
                        const SizedBox(width: 5),
                        
                        // Logo image
                        setLogoPath(),
                      ],
                    ),
                        
                  const SizedBox(height: 7), // Space between top row and text

                  // Row for Price and Stock
                  Row(
                    children: <Widget>[
                    
                      // Price Heading
                      Expanded(

                      child: Container(
                        padding: EdgeInsets.all(5), // Space around the text inside the box
                        decoration:  BoxDecoration(
                          color: const Color(0xFFDDDEE1),
                          borderRadius: BorderRadius.circular(8), // Rounded corners of the box
                        ),
                        alignment: Alignment.center,
                        
                        child: Text(
                            'Price: \$${item.price.toStringAsFixed(2)}',
                              style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 25), //Space between Headings in row
                      
                      Expanded(
                      child: Container(
                        padding: EdgeInsets.all(5), // Space around the text inside the box
                        decoration: BoxDecoration(
                        color: const Color(0xFFDDDEE1),
                        borderRadius: BorderRadius.circular(8), // Rounded corners of the box
                      ),
                      alignment: Alignment.center,
                        child:Text(
                        'Payout: \$${(item.price * (item.commission / 100)).toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    ),
                      
                  ],
                ),

                const SizedBox(height: 5), // Space between rows

                // Row for Commission and Payout
                Row(
                  children: <Widget>[
                    // Commission Heading
                    
                    // Last Updated
                      Expanded(

                        child: Container(
                        padding: EdgeInsets.all(5), // Space around the text inside the box
                        decoration: BoxDecoration(
                          color: const Color(0xFFDDDEE1),
                          borderRadius: BorderRadius.circular(8), // Rounded corners of the box
                        ),
                        alignment: Alignment.center,
                        
                        child: Text(
                          'Rate: ${item.commission}%', 
                          style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          ),
                          textAlign: TextAlign.right,
                          
                        ),
                      ),
                    ),
                    const SizedBox(width: 25),

                    // Payout Heading
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(5), // Space around the text inside the box
                        decoration: BoxDecoration(
                          color: const Color(0xFFDDDEE1),
                            borderRadius: BorderRadius.circular(8), // Rounded corners of the box
                          ),
                        alignment: Alignment.center,
                        child:Text(
                        item.dateFormatter(), 
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                    ),
                  ],
                ),
                const SizedBox(height: 10), // Space between content and final row

                // Final row with custom text spanning the card
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(2), // Space around the text inside the box
                        decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        color: Colors.grey[200], // Background color of the box
                          borderRadius: BorderRadius.circular(4), // Rounded corners of the box
                        ),
                        alignment: Alignment.center,
                      child: const Text(
                        'This offer is recomended due to its good price and high stock availability', // Replace with dynamic text if needed
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
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
    Widget logoPath = Image.asset('assets/images/impact_logo.webp',
                          height: 25,
                          alignment: Alignment.centerLeft, );
    if (item.network == "eBay") {
      logoPath = Image.asset('assets/images/ebay_logo.png',
                          height: 25,
                          alignment: Alignment.centerLeft, );
    }
    
    return logoPath;
  }

}
