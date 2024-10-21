
import 'package:flutter/material.dart';
import 'package:shop_app/objects/Barchart.dart';
import 'package:shop_app/objects/Piechart.dart';
import '../../product_details/product_details_screen.dart';
import '../../../objects/Product.dart'; 

class NetworkAverageCard extends StatelessWidget {
  final List<double> data;
  final List<String> xLabels;
  const NetworkAverageCard({super.key, required this.data, required this.xLabels });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
     
      },
        
        child: SizedBox(
          height: 190, 
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
                      color: Color(0xFFff9585), // Background color of the box
                      borderRadius: BorderRadius.circular(8), // Rounded corners of the box
                      ),
                    alignment: Alignment.center,
                    child:
               const Text(
                "Offers Price Distribution",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
        ),
        
        
        SizedBox(height:3),
        
        // Logo image
        //setLogoPath(), 
        SizedBox(height: 5), // Space between top row and content
        
        // Container to take up the rest of the card space
        Expanded(
          child: Container(
                height: 115,
                child: CustomBarChart(data: data, xLabels: xLabels,),
            ),
          ),
      ],
    ),
  ),
          ),
        ),
    );
  }

 
  //Find average

  //Make graph
}
