import 'package:flutter/material.dart';
import 'package:shop_app/components/product_card.dart';
import 'package:shop_app/screens/Scan%20History/components/history_item.dart';
import '/objects/product.dart';
import 'package:flutter/material.dart';
import '../../../objects/product.dart'; 
import 'package:http/http.dart' as http;
import 'dart:convert';
//import '../product_details/product_details_screen.dart';

class SearchHistoryScreen extends StatelessWidget {
  static String routeName = "/searchHistory";
 SearchHistoryScreen({super.key});

 final List<Product> demoProducts = [
  Product(
    title: "LEGO Star Wars: Captain Rex Y-Wing Microfighter - (75391)",
    imagePath: "https://www.bigw.com.au/medias/sys_master/images/images/h08/h51/49514013425694.jpg",
    price: 64.99,
    description: "Let kids team up with a popular Star Wars: The Clone Wars character on playtime missions with this LEGO? brick-built Captain Rex Y-Wing Microfighter (75391) starship toy. A fun fantasy gift idea for creative boys  girls and any young fan aged 6 and up  this buildable vehicle toy playset features the first-ever LEGO Star Wars? construction model of Captain Rex?s Y-wing. Designed to be easy to build so the action starts fast  this miniature version of the iconic Star Wars starfighter has a minifigure cockpit and 2 stud shooters  and the included Captain Rex LEGO minifigure comes with 2 blasters. Add another dimension to your child?s creative experience with the LEGO Builder app  featuring instructions and digital zoom and rotate viewing tools to help them build with confidence. This small set is part of a fun collectible series of quick-build LEGO Star Wars Microfighters (sold separately)  which can be matched up for even more brick-built action-adventures.",
    currency:"USD",
    brand:"LEGO",
    commission:1.23,
    category:"Toys", 
    network:"impact.com",
    isFavourite: true,
  ),

  Product(
    title: "LEGO Star Wars: Boading the tantic",
    imagePath: "https://assets.mydeal.com.au/48517/lego-75387-star-wars-boarding-the-tantive-iv-11607678_00.jpg?v\u003d638562396326161647\u0026imgclass\u003ddealgooglefeedimage",
    price: 149.99,
    description: "Let kids team up with a popular Star Wars: The Clone Wars character on playtime missions with this LEGO? brick-built Captain Rex Y-Wing Microfighter (75391) starship toy. A fun fantasy gift idea for creative boys  girls and any young fan aged 6 and up  this buildable vehicle toy playset features the first-ever LEGO Star Wars? construction model of Captain Rex?s Y-wing. Designed to be easy to build so the action starts fast  this miniature version of the iconic Star Wars starfighter has a minifigure cockpit and 2 stud shooters  and the included Captain Rex LEGO minifigure comes with 2 blasters. Add another dimension to your child?s creative experience with the LEGO Builder app  featuring instructions and digital zoom and rotate viewing tools to help them build with confidence. This small set is part of a fun collectible series of quick-build LEGO Star Wars Microfighters (sold separately)  which can be matched up for even more brick-built action-adventures.",
    currency:"USD",
    brand:"LEGO",
    commission:4.50,
    category:"Toys", 
    network:"impact.com",
    isFavourite: true,
  ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Scan History', 
        style: Theme.of(context).textTheme.titleLarge,),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            color: Colors.grey[300],
            width: double.infinity,
            height: 1,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent searches',
                  style: TextStyle(fontSize: 18, color: Colors.grey[400]),
                  
                ),
                TextButton(
                  onPressed: () {
                    // Implement clear functionality here
                  },
                  child: Text(
                    'Clear',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),
          
          Container(
            color: Colors.grey[300],
            width: double.infinity,
            height: 1,
          ),
         ...demoProducts.map((p) => HistoryItemCard(item: p, )).toList(),
        ],
      ),
    );
  }
}