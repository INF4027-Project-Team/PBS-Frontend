import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../../product_details/product_details_screen.dart';
import '../../../objects/Product.dart';

class ItemDisplayCard extends StatelessWidget {
  final Product item;
  final List<Product> specialOffers;

  const ItemDisplayCard({super.key, required this.item, required this.specialOffers});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DetailsScreen(productDetails: item)), 
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        child: SizedBox(
          height: 170,
          child: Card(
            margin: const EdgeInsets.all(8),
            color: const Color(0xFFF5F6F9),
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Top row displaying network image and Best Offer symbol
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Center(
                          child: Image.asset(
                            setLogoPath(),
                            height: 35,
                          ),
                        ),
                      ),
                      // Best Offer container
                      Container(
                        width: 80,
                        child: Container(),
                      ),
                    ],
                  ),
                  SizedBox(height: 10), // Space between top row and text
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Image.network(
                        item.imagePath,
                        height: 80,
                        width: 80,
                        alignment: Alignment.centerLeft,
                      ),
                      SizedBox(width: 10), // Space between image and text
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('${limitString(item.title, 23)}'),
                          Text('Price (${item.currency}): ${item.price.toStringAsFixed(2)}'),
                          SizedBox(height: 5), // Adjust spacing between texts if needed
                          Text(
                            'Commission: ${item.commission}% (${(item.price * (item.commission / 100)).toStringAsFixed(2)})',
                          ),
                        ],
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

  // Gets the image path for the given network
  String setLogoPath() {
    String logoPath = 'assets/images/impact_logo.webp';
    if (item.network == "eBay") {
      logoPath = 'assets/images/ebay_logo.png';
    }
    return logoPath;
  }

  String limitString(String text, int limit) {
  if (text.length <= limit) {
    return text;
  } else {
    return text.substring(0, limit) + '...';
  }
}
}
