
import 'package:flutter/material.dart';
import 'package:shop_app/objects/Barchart.dart';
import 'package:shop_app/objects/Piechart.dart';
import '../../product_details/product_details_screen.dart';
import '../../../objects/Product.dart'; 

class NetworkAverageCard extends StatelessWidget {
  final double impactAvg;
  final double ebayAvg;
  final String heading;
  const NetworkAverageCard({super.key, required this.impactAvg, required this.ebayAvg, required this.heading});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
     
      },
        
        child: SizedBox(
          height: 180, 
          width: 95,
          child: Card(
            margin: EdgeInsets.all(8),
            color: Color(0xFFF5F6F9),
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
                      color: Colors.greenAccent, // Background color of the box
                      borderRadius: BorderRadius.circular(8), // Rounded corners of the box
                      ),
                    alignment: Alignment.center,
                    child:
               Text(
                heading,
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
        SizedBox(height: 5), // Space between top row and content
        
        // Container to take up the rest of the card space
        Expanded(
          child: Container(
                height: 115,
                width: 95,
                child: (heading == "Ttl Offers") ? CustomPieChart(value1: impactAvg, value2: ebayAvg): CustomBarChart(value1: impactAvg, value2: ebayAvg),
            ),
          ),
      ],
    ),
  ),
          ),
        ),
    );
  }

 Widget setLogoPath() {
    Widget logoPath = Image.asset('assets/images/impact_logo.webp',
                          height: 25,
                          alignment: Alignment.centerLeft, );
    if (ebayAvg > impactAvg ) {
      logoPath = Image.asset('assets/images/ebay_logo.png',
                          height: 25,
                          alignment: Alignment.centerLeft, );
    }
    
    return logoPath;
  }
  //Find average

  //Make graph
}
