import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import '../../product_details/product_details_screen.dart';
import '../../../objects/Product.dart'; 

enum offerType { price, stock, rate, payout }
class SpecialOffersCard extends StatelessWidget {
  final Product item;
  final offerType textHeading;
  final List<Product> products;
  

  const SpecialOffersCard({super.key, required this.item, required this.textHeading, required this.products});

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
  margin: const EdgeInsets.all(4),
  color: const Color(0xFFF5F6F9),
  elevation: 0,
  
  child: Padding(
    padding: const EdgeInsets.all(5),
    
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // Top row displaying title text
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
      Icon(
        getIcon(textHeading),  // Choose the icon you want
        color: Colors.grey,  // Set icon color
        size: 18,  // Set icon size
      ),
      SizedBox(width: 4), // Add space between the icon and text
      Text(
        getTitle(textHeading),
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    ],
  ),
),
        
        
        SizedBox(height:5),
        
        // Logo image
        setLogoPath(), 

        SizedBox(height:5 ),
                             
        
        // Container to take up the rest of the card space
        Expanded(
          child: Padding(
            padding: EdgeInsets.fromLTRB(15,2,15,2),

          child: Container(
            padding: EdgeInsets.all(4), // Space around the text inside the box
            decoration: BoxDecoration(
                          //color: getStatusColor(textHeading), // Background color of the box
              color: const Color(0xFFDDDEE1),
              borderRadius: BorderRadius.circular(6), // Rounded corners of the box
            ),
                        alignment: Alignment.center, // Or any other color for the background
      
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center, // Aligns texts to the start (left)
                          children: [

                            

                            Text(
                              getValue(textHeading),
                              style: TextStyle(
                                fontSize: (textHeading == offerType.stock) ? 17 : 21,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),

                            
                            Text(
                              getAvg(textHeading), // Replace with your second text
                              style: const TextStyle(
                                fontSize: 11, // Set a different font size if needed
                                fontWeight: FontWeight.w600,
                                color: Colors.black, // Slightly lighter color for differentiation
                              ),
                            ),
                          ],
                        ),
                
            ),),
            
          ),

          Container(
             padding: EdgeInsets.all(1),
             
            alignment: Alignment.center,
            child: Text(
                              "Offer ID: ${item.id}",
                              style: const TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
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
                          height: 30,
                          alignment: Alignment.centerLeft, );
    if (item.network == "eBay") {
      logoPath = Image.asset('assets/images/ebay_logo.png',
                          height: 30,
                          alignment: Alignment.centerLeft, );
    }
    
    return logoPath;
  }


  List<Color> getStatusColor(offerType type) {
  switch (type) {
    case offerType.price:
      return [Color(0xFFC0C0C0), Color(0xFFE0E0E0),];
    case offerType.payout:
      return [const Color(0xFFff9585), const Color(0xFFffcaab)];
    case offerType.rate:
      return [const Color(0xFFff9585), const Color(0xFFffcaab)];
    case offerType.stock:
      return [Color(0xFFC0C0C0), Color(0xFFE0E0E0),];
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


  String getAvg(offerType type) {
  switch (type) {
    case offerType.price:
      String avg = item.averagePrice(products).toStringAsFixed(2);
      return "vs Avg of \$$avg";
    case offerType.payout:
      String avg = item.averagePayout(products).toStringAsFixed(2);
      return "vs Avg of \$$avg";
    case offerType.rate:
      String avg = item.averageCommission(products).toStringAsFixed(2);
      return "vs Avg of $avg%";
    case offerType.stock:
       DateTime parsedDate = DateTime.parse(item.mostRecentDate);
    
        // Get the current date
        DateTime currentDate = DateTime.now();
        
        // Calculate the difference in days between the current date and the parsed date
        int daysDifference = currentDate.difference(parsedDate).inDays;
        
        // Return the result in the desired format
        return '($daysDifference day(s) ago)';
     // return "";
    }    
  }

    IconData getIcon(offerType type)
    {
      switch (type) {
    case offerType.price:
      return Icons.attach_money;
    case offerType.payout:
      return Icons.savings_outlined;
    case offerType.rate:
      return Icons.percent;
    case offerType.stock:
      return Icons.new_releases_outlined;
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
      return item.dateFormatter();
    }

    
  }



}