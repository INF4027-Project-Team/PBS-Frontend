import 'package:flutter/material.dart';
import "package:pbs/src/objects/product.dart";
import 'package:pbs/src/screens/view_offers.dart';
import "package:pbs/src/widgets/network_display_card.dart";
import 'package:google_fonts/google_fonts.dart';

class NetworkResults extends StatelessWidget {
  final Color impactGrey = const Color(0xFFC9C8CA);
  final Color impactRed = const Color(0xFFF4333C);
  final Color impactBlack = const Color(0xFF040404);
  final List<Product> impactOffers;
  final List<Product> ebayOffers;
  final int totalOffers;
  final String productName;

  NetworkResults({
    super.key,
    required this.impactOffers,
    required this.ebayOffers,
    
  } ): totalOffers = impactOffers.length + ebayOffers.length, productName = impactOffers[0].name ;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: impactGrey,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.home, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
             Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(  // Wrap the Text widget with a Center widget to center it horizontally
                child: Text(
                   'Scan Successful!\n\n${totalOffers} Offers found for \n$productName',
                    style: GoogleFonts.montserrat(  // Using Montserrat from Google Fonts
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            NetworkDisplayCard(
              logoPath: 'assets/images/impact_logo.webp',
              siteName: 'impact.com',
              offersCount: impactOffers.length,
              onTap: () {
                // Navigation logic to the detail screen
                Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductList(products: impactOffers, networkName: "impact.com", productName: productName),
                      ),
                    );
              },
            ),
            NetworkDisplayCard(
              logoPath: 'assets/images/ebay_logo.png',
              siteName: 'eBay',
              offersCount: ebayOffers.length,
              onTap: () {
                // Navigation logic to the detail screen
                Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductList(products: ebayOffers, networkName: "eBay", productName: productName),
                      ),
                    );
              },
            ),
            SizedBox(height: 60), // Provides spacing before the button
            Center( // Center the button within the horizontal space
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: OutlinedButton(
                  onPressed: () {
                    // Add your button tap functionality here
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.purple, width: 2), // Purple border
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // Curved edges
                    ),
                    foregroundColor: Colors.purple, // Text color
                  ),
                  child: Text(
                    'View All Offers',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


