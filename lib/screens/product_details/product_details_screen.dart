import 'package:flutter/material.dart';
import 'package:shop_app/database%20access/database_service.dart';
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

  // Impact Colours
  final Color impactGrey = const Color(0xFFC9C8CA);
  final Color impactRed = const Color(0xFFF4333C);
  final Color impactBlack = const Color(0xFF040404);

  // Other interface colours
  final Color softPurple = const Color(0xFFAA62B7);
  final Color gloomyPurple = const Color(0xFF8A4EDD);

  final Product product; // Parameter to hold the word
  bool isFav;

  // Constructor to receive the word parameter
  DetailsScreen({super.key, required Product productDetails, bool fav = false})
      : product = productDetails,
        isFav = fav;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F9),
      appBar: _buildAppBar(context),
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
                      Image.asset(setLogoPath(), width: 130),
                      ProductDescription(product: product),
                    ],
                  ),
                ),
                TopRoundedContainer(
                  color: const Color(0xFFF6F7F9),
                  child: Column(
                    children: [
                      _buildDetailRow("Brand: ${product.brand}"),
                      _buildDetailRow('Price (${product.currency}): ${product.price.toStringAsFixed(2)}'),
                      _buildDetailRow(
                          'Commission On Sale (${product.currency}): ${(product.price * (product.commission / 100)).toStringAsFixed(2)} (${product.commission}%)'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  // Helper function to build AppBar
  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text('Product Details', style: Theme.of(context).textTheme.titleLarge),
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: EdgeInsets.zero,
            elevation: 0,
            backgroundColor: Colors.white,
          ),
          child: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
        ),
      ),
      actions: [
        IconButton(onPressed: () => Navigator.pushNamed(context, InitScreen.routeName), icon: const Icon(Icons.home)),
        const SizedBox(width: 10),
        IconButton(onPressed: () => Navigator.pushNamed(context, SearchHistoryScreen.routeName), icon: const Icon(Icons.history)),
      ],
    );
  }

  // Helper function to build bottom navigation bar
  Widget _buildBottomNavBar(BuildContext context) {
    return TopRoundedContainer(
      color: Colors.white,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 5),
          child: Row(
            children: [
              _buildShareButton(context),
              Container(height: 60, width: 0.65, color: impactGrey),
              _buildAIShareButton(context),
            ],
          ),
        ),
      ),
    );
  }

  // Helper function to build share button
  Widget _buildShareButton(BuildContext context) {
    return GestureDetector(
      onTap: () => Share.share(product.webLink),
      child: Container(
        width: 270,
        height: 60,
        decoration: const BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            bottomLeft: Radius.circular(12),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: const Center(
          child: Text("Share", style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }

  // Helper function to build AI-powered share button
  Widget _buildAIShareButton(BuildContext context) {
    return GestureDetector(
      onTap: () => _showAISocialMediaDialog(context),
      child: Container(
        width: 40,
        height: 60,
        decoration: const BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(12),
            bottomRight: Radius.circular(12),
          ),
        ),
        child: const Center(child: Icon(Icons.create, color: Colors.white)),
      ),
    );
  }

  // Helper function to show AI caption generation dialog
  void _showAISocialMediaDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Share with AI Powered Captions'),
          content: const Text('Choose a Platform for Caption Generation',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          actions: [
            _buildSocialMediaButton(context, 'Instagram', '/generateInstagramCaptionForProduct'),
            _buildSocialMediaButton(context, 'Twitter', '/generateTwitterCaptionForProduct'),
            _buildSocialMediaButton(context, 'Facebook', '/generateFacebookCaptionForProduct'),
          ],
        );
      },
    );
  }

  // Helper function to build social media buttons in the dialog
  Widget _buildSocialMediaButton(BuildContext context, String platform, String endpoint) {
    return TextButton(
      onPressed: () async {
        _showLoadingDialog(context);
        DatabaseService db = DatabaseService();
        String caption = await db.getAICaption(product, endpoint);
        Share.share('$caption \n ${product.webLink}');
        Navigator.pop(context); // Close the dialog
      },
      child: Center(
        child: Text(platform, style: const TextStyle(color: Colors.black, fontSize: 16)),
      ),
    );
  }

  // Helper function to show loading dialog
  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => const Center(child: CircularProgressIndicator()),
    );
  }

  // Helper function to build detail rows
  Widget _buildDetailRow(String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 2.0, 40.0, 2.0),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: impactGrey, width: 1.0)),
        ),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(text),
        ),
      ),
    );
  }

  // Helper function to set the logo path
  String setLogoPath() {
    product.isFavourite = isFav;
    String logoPath = 'assets/images/impact_logo.webp';
    if (product.network == "eBay") {
      logoPath = 'assets/images/ebay_logo.png';
    }
    return logoPath;
  }
}

class ProductDetailsArguments {
  final Product product;
  ProductDetailsArguments({required this.product});
}
