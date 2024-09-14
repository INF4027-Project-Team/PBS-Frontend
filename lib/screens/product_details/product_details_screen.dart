import 'package:flutter/material.dart';
import 'package:shop_app/screens/init_screen.dart';
import 'package:shop_app/screens/scan_history/search_history.dart';
import '../../objects/Product.dart';
import 'components/product_description.dart';
import 'components/product_images.dart';
import 'components/top_rounded_container.dart';
import 'package:shop_app/screens/cart/cart_screen.dart';
import 'package:share_plus/share_plus.dart';
class DetailsScreen extends StatelessWidget {
  
  static String routeName = "/details";

  //Impact Colours


  final Color impactGrey = const Color(0xFFC9C8CA);
  final Color impactRed = const Color(0xFFF4333C);
  final Color impactBlack = const Color(0xFF040404);

  //Other interface colours
  final Color softPurple = const Color(0xFFAA62B7);
  final Color gloomyPurple = const Color(0xFF8A4EDD);

  final Product product; // Parameter to hold the word
  bool isFav;
  //ResultsScreen({super.key});
  // Constructor to receive the word parameter
   DetailsScreen({super.key, required Product productDetails, bool fav= false})
      : product = productDetails, isFav = fav;
    


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F9),
     appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Product Details',
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
      body: ListView(
        children: [
          const SizedBox(height: 20),
          ProductImages(product: product),
          TopRoundedContainer(
            
            color: Colors.white,
            child: Column(
              
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Column(
                    children: [
                      Image.asset(
                        setLogoPath(),
                        width: 130,
                      ),
                      ProductDescription(product: product,),
                    ],
                  ),
                ),
                TopRoundedContainer(
                  color: const Color(0xFFF6F7F9),
                  child: Column(
                    children: [
                      // Manufacturer label
                      _buildDetailRow("Brand: ${product.brand}"),
                      // Cheapest Price Label
                      _buildDetailRow('Price (${product.currency}): ${product.price.toStringAsFixed(2)}'),
                      // Highest Commission Label
                      _buildDetailRow('Commission On Sale (${product.currency}): ${(product.price * (product.commission / 100)).toStringAsFixed(2)} (${product.commission}%)'),
                    ],
                  ),
                ),
              ],

            ),
          ),
        ],
      ),
      bottomNavigationBar: TopRoundedContainer(
        color: Colors.white,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: ElevatedButton(
              onPressed: () {
                //Navigator.pushNamed(context, CartScreen.routeName);
                final String content = 'Check out this awesome content!';
                Share.share(content);
              },
              child: const Text("Share"),
            ),
          ),
        ),
      ),
    );
  }

  // Helper function to build detail rows
  Widget _buildDetailRow(String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 2.0, 40.0, 2.0),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: impactGrey,
              width: 1.0,
            ),
          ),
        ),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            text,
            // style: TextStyle(fontSize: 18, color: impactBlack),
          ),
        ),
      ),
    );
  }


  String setLogoPath()
  {
    product.isFavourite = isFav;
    String logoPath = 'assets/images/impact_logo.webp';
    if (product.network == "eBay")
    {
      logoPath = 'assets/images/ebay_logo.png';
    }

    return logoPath;

  }
}



class ProductDetailsArguments {
  final Product product;
  ProductDetailsArguments({required this.product});
}
