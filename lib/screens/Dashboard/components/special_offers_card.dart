
import 'package:flutter/material.dart';
import '../../product_details/product_details_screen.dart';
import '../../../objects/Product.dart'; 

enum offerType { price, stock, rate, payout }
class SpecialOffersCard extends StatelessWidget {
  final Product item;
  final offerType textHeading;
  

  const SpecialOffersCard({super.key, required this.item, required this.textHeading});

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
          height: 100, 
          width: 115,

          child: Card(
  margin: const EdgeInsets.all(15),
  color: const Color(0xFFF5F6F9),
  elevation: 0,
  
  child: Padding(
    padding: const EdgeInsets.all(10),
    
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // Top row displaying title text
               Container(
                      padding: EdgeInsets.all(1), // Space around the text inside the box
                      decoration: BoxDecoration(
                      color: getStatusColor(textHeading), // Background color of the box
                      borderRadius: BorderRadius.circular(8), // Rounded corners of the box
                      ),
                    alignment: Alignment.center,
                    child: Text(
                      getTitle(textHeading),
                      style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                ),
              ),
               ),
        
        
        SizedBox(height:3),
        
        // Logo image
        setLogoPath(), 
        SizedBox(height: 10), // Space between top row and content
        
        // Container to take up the rest of the card space
        Expanded(
          child: Container(
            padding: EdgeInsets.all(2), // Space around the text inside the box
                        decoration: BoxDecoration(
                          color: getStatusColor(textHeading), // Background color of the box
                          border: Border.all(
                            color: getStatusColor(textHeading), // Border color of the box
                            width: 1, // Border width
                          ),
                          borderRadius: BorderRadius.circular(8), // Rounded corners of the box
                        ),
                        alignment: Alignment.center, // Or any other color for the background
            child: 
                Text(
                  getValue(textHeading), 
                style: const TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w600,),
                ),  
                
            ),
          ),
      ],
    ),
  ),
)

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


  Color getStatusColor(offerType type) {
  switch (type) {
    case offerType.price:
      return Colors.lightGreenAccent;
    case offerType.payout:
      return Colors.lightBlueAccent;
    case offerType.rate:
      return Color.fromARGB(255, 246, 172, 61);
    case offerType.stock:
      return Color.fromARGB(255, 250, 234, 87);
    }
  }

  String getTitle(offerType type) {
  switch (type) {
    case offerType.price:
      return "Lowest Price";
    case offerType.payout:
      return "Highest Payout";
    case offerType.rate:
      return "Highest Rate";
    case offerType.stock:
      return "Latest Offer";
    }

    
  }

  String getValue(offerType type) {
  switch (type) {
    case offerType.price:
      return '\$${item.price.toStringAsFixed(2)}';
    case offerType.payout:
      return '\$${(item.price * (item.commission / 100)).toStringAsFixed(2)}';
    case offerType.rate:
      return '${item.commission.toStringAsFixed(2)}%';
    case offerType.stock:
      return "12/08/2024";
    }

    
  }



}