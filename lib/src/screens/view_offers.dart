import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../objects/product.dart';  // Assuming this is the correct import path
import '../widgets/product_display_card.dart';

class ProductList extends StatelessWidget {
  // Impact Colors
  final Color impactGrey = const Color(0xFFC9C8CA);
  final Color impactRed = const Color(0xFFF4333C);
  final Color impactBlack = const Color(0xFF040404);
  final List<Product> products;
  final String productName;
  final String networkName;

  const ProductList({
    super.key,
    required this.products,
    required this.productName,
    required this.networkName,
  });

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
            if (networkName == 'eBay') 
              Center(
                child: Image.asset('assets/images/ebay_logo.png', 
                  width: 200.0,  // Specify the width of the image
                  height: 100.0,  // Specify the height of the image
                  fit: BoxFit.contain,
                  ),
              )
            else if (networkName == 'impact.com')
              Center(
                child: Image.asset('assets/images/impact_logo.webp', 
                  width: 200.0,  // Specify the width of the image
                  height: 100.0,  // Specify the height of the image
                  fit: BoxFit.contain,),  // Centered Impact image
              ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  'All Offers Available for \n$productName',
                  style: GoogleFonts.montserrat(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  const Text(
                    'Sort By: ',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 20.0),  // Adds space between the label and the dropdown
                  DropdownButton<String>(
                    value: 'Price Ascending',  // default value
                    icon: const Icon(Icons.arrow_downward),
                    elevation: 16,
                    style: const TextStyle(color: Colors.deepPurple),
                    underline: Container(
                      height: 2,
                      color: Colors.deepPurpleAccent,
                    ),
                    onChanged: (String? newValue) {
                      // handle sorting logic here
                    },
                    items: <String>[
                      'Price Ascending',
                      'Price Descending',
                      'Commission Ascending',
                      'Commission Descending'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                        onTap: () {},
                      );
                    }).toList(),
                    dropdownColor: impactGrey,  // Adjusted to white for clarity
                  ),
                ],
              ),
            ),
            ...products.map((p) => ProductDisplayCard(item: p)).toList(),
          ],
        ),
      ),
    );
  }
}
