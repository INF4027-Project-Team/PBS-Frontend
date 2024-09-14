import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:shop_app/screens/Dashboard/components/featured_offer_card%20copy.dart';
import 'package:shop_app/screens/Dashboard/components/network_average_card.dart';
import 'package:shop_app/screens/Dashboard/components/special_offers_card.dart';
import 'package:shop_app/screens/init_screen.dart';
import 'package:shop_app/screens/scan_history/search_history.dart';
import '../../objects/Product.dart'; 
import 'package:http/http.dart' as http;
import 'dart:convert';

class Dashboard extends StatefulWidget {
  final List<Product> products;
  final List<Product> specialOffers;

  const Dashboard({
    Key? key,
    required this.products,
    required this.specialOffers,
  }) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late List<Product> _currentProducts;
  late List<Product> _specialProducts;
  String _selectedSort = 'Relevance'; // State variable for dropdown value

  @override
  void initState() {
    super.initState();
    _currentProducts = widget.products;
    _specialProducts = widget.specialOffers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Dashboard',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: EdgeInsets.zero,
              elevation: 0,
              backgroundColor: Colors.white,
            ),
            child: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
              size: 20,
            ),
          ),
        ),
        actions: [
          IconButton(onPressed: ()=>{Navigator.pushNamed(context, InitScreen.routeName)}, icon: Icon(Icons.home)),
          SizedBox(width: 10),
          IconButton(onPressed: ()=>{Navigator.pushNamed(context, SearchHistoryScreen.routeName)}, icon: Icon(Icons.history)),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Featured offer at the top
            FeaturedOfferCard(
              item: _specialProducts[0],
            ),

            
      //SizedBox(height: 8.0), // Add some spacing between sections

      // Grid of 4 special offer cards in a 2x2 layout
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0.5),
        child: GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 columns
            crossAxisSpacing: 1.0,
            mainAxisSpacing: 1.0,
            childAspectRatio: 1.15, 
            // Adjust as needed
          ),
          itemCount: 4, // Number of special offer cards
          itemBuilder: (context, index) {
            // Example list of parameters for each card
            
            print(index);
            print(_specialProducts[index].specialtyType);
            // Pass different parameters to each SpecialOffers card
            return SpecialOffersCard(
              item: _specialProducts[index],
              textHeading: _specialProducts[index].specialtyType,
            );
          },
        ),
      ),

      //SizedBox(height: 8.0), // Add some spacing between sections

      // Row of 3 network offer cards
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(3, (index) {

            // Example list of parameters for each card
            final List<List<double>>networkAverageParameters = [
              [100, 68],
              [23, 45],
              [56, 120],
            ];

            final List<String> charts = [
              "Avg Price",
              "Avg Rate",
              "Ttl Offers",
            ];
            // Pass different parameters to each NetworkAverage card
            return Expanded(
              child: NetworkAverageCard(
                impactAvg: networkAverageParameters[index][0],
                ebayAvg: networkAverageParameters[index][1],
                heading: charts[index],
              ),
            );
          }),
        ),
      ),
          ],
        ),
      ),

    );
  }
}