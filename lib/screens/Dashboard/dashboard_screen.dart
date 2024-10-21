import 'dart:async'; // Import for asynchronous operations
import 'package:flutter/material.dart';
import 'package:shop_app/database%20access/database_service.dart';
import 'package:shop_app/screens/Dashboard/components/featured_offer_card%20copy.dart';
import 'package:shop_app/screens/Dashboard/components/network_average_card.dart';
import 'package:shop_app/screens/Dashboard/components/special_offers_card.dart';
import 'package:shop_app/screens/init_screen.dart';
import 'package:shop_app/screens/scan_history/search_history.dart';
import '../../objects/Product.dart'; 

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
  
  String? _caption; // New instance variable for caption

  @override
  void initState() {
    super.initState();
    _loadCaptionAndProducts(); // Call the function to load caption and products
  }

  Future<void> _loadCaptionAndProducts() async {
    // Simulate waiting for the caption (e.g., from a service or input)
    _caption = await _fetchCaption();
    
    // After the caption is fetched, set the products
    setState(() {
      _currentProducts = widget.products;
      _specialProducts = widget.specialOffers;
    });
  }

  Future<String> _fetchCaption() async {
    // Simulate a delay and fetching the caption
    DatabaseService db = DatabaseService();
    return await db.getRecommendedCaption(_currentProducts[0]); // Simulating a 2-second delay
    
  }

  @override
  Widget build(BuildContext context) {
    // Check if caption is loaded
    if (_caption == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()), // Show a loader while waiting for caption
      );
    }

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
          IconButton(onPressed: ()=>{Navigator.pushNamed(context, InitScreen.routeName)}, icon: const Icon(Icons.home)),
          const SizedBox(width: 10),
          IconButton(onPressed: ()=>{Navigator.pushNamed(context, SearchHistoryScreen.routeName)}, icon: const Icon(Icons.history)),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Featured offer at the top
            FeaturedOfferCard(
              item: _specialProducts[0],
              caption: _caption,
            ),

            // Grid of 4 special offer cards in a 2x2 layout
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0.5),
              child: GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 columns
                  crossAxisSpacing: 1.0,
                  mainAxisSpacing: 1.0,
                  childAspectRatio: 1.15,
                ),
                itemCount: 4,
                itemBuilder: (context, index) {
                  return SpecialOffersCard(
                    item: _specialProducts[index],
                    textHeading: _specialProducts[index].specialtyType,
                    products: _currentProducts,
                  );
                },
              ),
            ),

            // Row of 3 network offer cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: NetworkAverageCard(
                data: _currentProducts[0].prepareHistogramRange(_currentProducts),
                xLabels: _currentProducts[0].histogramXAxis(_currentProducts),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Other methods to calculate prices and offers

  double getEbayAvgPrice() {
    List<double> avg = _currentProducts[0].averageAffiliatePrice(_currentProducts);
    return avg[1];
  }

  double getImpactAvgPrice() {
    List<double> avg = _currentProducts[0].averageAffiliatePrice(_currentProducts);
    return avg[0];
  }

  double getEbayAvgRate() {
    List<double> avg = _currentProducts[0].averageAffiliateComissions(_currentProducts);
    return avg[1];
  }

  double getImpactAvgRate() {
    List<double> avg = _currentProducts[0].averageAffiliateComissions(_currentProducts);
    return avg[0];
  }

  int? getEbayOfferCount() {
    Map<String, int> count = _currentProducts[0].affiliateOfferCounts(_currentProducts);
    return count["eBay"];
  }

  int? getImpactOfferCount() {
    Map<String, int> count = _currentProducts[0].affiliateOfferCounts(_currentProducts);
    return count["impact.com"];
  }
}
