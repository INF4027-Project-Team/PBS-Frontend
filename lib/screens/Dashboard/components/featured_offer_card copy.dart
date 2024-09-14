
import 'package:flutter/material.dart';
import 'package:shop_app/screens/Dashboard/components/special_offers_card.dart';
import '../../product_details/product_details_screen.dart';
import '../../../objects/Product.dart'; 

class FeaturedOfferCard extends StatelessWidget {
  final Product item;

  const FeaturedOfferCard({super.key, required this.item, });

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
        height: 230,

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
                            padding: EdgeInsets.all(1), // Space around the text inside the box
                            decoration: BoxDecoration(
                            color: Color(0xFFF4333C), // Background color of the box
                            borderRadius: BorderRadius.circular(8), // Rounded corners of the box
                            ),
                          alignment: Alignment.center,

                          child: const Text(
                            'Recommended Offer',
                            style: TextStyle(
                            fontSize: 21,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                        // Network image (logo)
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
                        decoration: BoxDecoration(
                          color: Colors.lightGreenAccent, // Background color of the box
                          border: Border.all(
                            color: Colors.green, // Border color of the box
                            width: 1, // Border width
                          ),
                          borderRadius: BorderRadius.circular(8), // Rounded corners of the box
                        ),
                        alignment: Alignment.center,
                        
                        child: Text(
                            '\$${item.price.toStringAsFixed(2)}',
                              style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 25), //Space between Headings in row

                      // In stock Heading
                      Expanded(

                        child: Container(
                        padding: EdgeInsets.all(5), // Space around the text inside the box
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 250, 234, 87), // Background color of the box
                          border: Border.all(
                            color: Colors.yellow, // Border color of the box
                            width: 1, // Border width
                          ),
                          borderRadius: BorderRadius.circular(8), // Rounded corners of the box
                        ),
                        alignment: Alignment.center,
                        
                        child: Text(
                          /*'${item.stock}*/ '5 in Stock', 
                          style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.right,
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
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(5), // Space around the text inside the box
                        decoration: BoxDecoration(
                        color: Color.fromARGB(255, 246, 172, 61), // Background color of the box
                        border: Border.all(
                          color: Colors.orange, // Border color of the box
                          width: 1, // Border width
                        ),
                        borderRadius: BorderRadius.circular(8), // Rounded corners of the box
                      ),
                      alignment: Alignment.center,
                        child:Text(
                        '\$${(item.price * (item.commission / 100)).toStringAsFixed(2)} Payout',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    ),

                    const SizedBox(width: 25),

                    // Payout Heading
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(5), // Space around the text inside the box
                        decoration: BoxDecoration(
                        color: Colors.lightBlueAccent, // Background color of the box
                        border: Border.all(
                          color: Colors.blue, // Border color of the box
                          width: 1, // Border width
                          ),
                          borderRadius: BorderRadius.circular(8), // Rounded corners of the box
                        ),
                        alignment: Alignment.center,
                        child:Text(
                        '${item.commission}% Rate', 
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600
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
                        color: Colors.grey[200], // Background color of the box
                        border: Border.all(
                          color: Colors.grey.shade300, // Border color of the box
                          width: 1, // Border width
                          ),
                          borderRadius: BorderRadius.circular(4), // Rounded corners of the box
                        ),
                        alignment: Alignment.center,
                      child: Text(
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
                          height: 27,
                          alignment: Alignment.centerLeft, );
    if (item.network == "eBay") {
      logoPath = Image.asset('assets/images/ebay_logo.png',
                          height: 27,
                          alignment: Alignment.centerLeft, );
    }
    
    return logoPath;
  }

}
