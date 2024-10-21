import 'package:flutter/material.dart';
import 'package:shop_app/database%20access/database_service.dart';
import 'package:shop_app/objects/AnalyticObject.dart';
import 'package:shop_app/objects/User.dart';
import 'package:shop_app/screens/Analytics/Components/counter_card.dart';
import 'package:shop_app/screens/Analytics/Components/topProducts.dart';
import 'package:shop_app/screens/init_screen.dart';
import 'package:shop_app/screens/scan_history/search_history.dart';

class AnalyticsBoard extends StatefulWidget {
  static String routeName = "/analytics";
  const AnalyticsBoard({Key? key}) : super(key: key);

  @override
  _AnalyticsState createState() => _AnalyticsState();
}

class _AnalyticsState extends State<AnalyticsBoard> {
  DatabaseService db = DatabaseService();
  late Future<AnalyticObject> analFuture;

  // Variables to control section visibility
  bool showProducts = true;
  bool showBrands = true;
  bool showCategories = true;

  @override
  void initState() {
    super.initState();
    analFuture = _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Analytics',
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
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, InitScreen.routeName);
            },
            icon: const Icon(Icons.home),
          ),
          const SizedBox(width: 10),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, SearchHistoryScreen.routeName);
            },
            icon: const Icon(Icons.history),
          ),
        ],
      ),
      body: FutureBuilder<AnalyticObject>(
        future: analFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            AnalyticObject? anal = snapshot.data;
            return SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Align(
                      alignment: Alignment.centerLeft,  // Ensure the content is aligned to the left
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        //decoration: BoxDecoration(
                        //  color: Colors.blue[400],
                        //  borderRadius: BorderRadius.circular(4),
                        //),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Your Stats',
                              style: TextStyle(fontSize: 22, color: Colors.black, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 12),
                            Icon(
                              Icons.stacked_bar_chart,
                              size: 20,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0.5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        CounterCard(
                          heading: "Total Scans",
                          count: anal?.totalScans,
                          iconImg: Icons.qr_code_scanner_sharp,
                        ),
                        CounterCard(
                          heading: "Total Shares",
                          count: anal?.totalShares,
                          iconImg: Icons.stacked_line_chart,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                          //decoration: BoxDecoration(
                           // color: Colors.blue[400],
                          //  borderRadius: BorderRadius.circular(6),
                         // ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Global Trends',
                                style: TextStyle(fontSize: 22, color: Colors.black, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(width: 12),
                              Icon(
                                Icons.trending_up_sharp,
                                size: 20,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.filter_list),
                          onPressed: () {
                            _showFilterDialog();
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 26.0),

                  // Conditional rendering based on filter
                  if (showProducts) _buildSection("Top Products", anal?.scannedProducts, anal?.favourateProducts, anal?.sharedProducts),
                  if (showBrands) _buildSection("Top Brands", anal?.scannedBrands, anal?.favouriteBrands, anal?.sharedBrands),
                  if (showCategories) _buildSection("Top Categories", anal?.scannedCategories, anal?.favourateCategories, anal?.sharedCategories),
                ],
              ),
            );
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
    );
  }

  // Filter dialog to select sections
  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Filter Sections"),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CheckboxListTile(
                    title: const Text("Top Products"),
                    value: showProducts,
                    onChanged: (bool? value) {
                      setState(() {
                        showProducts = value!;
                      });
                    },
                    activeColor: Colors.red,
                  ),
                  CheckboxListTile(
                    title: const Text("Top Brands"),
                    value: showBrands,
                    onChanged: (bool? value) {
                      setState(() {
                        showBrands = value!;
                      });
                    },
                    activeColor: Colors.red,
                  ),
                  CheckboxListTile(
                    title: const Text("Top Categories"),
                    value: showCategories,
                    onChanged: (bool? value) {
                      setState(() {
                        showCategories = value!;
                      });
                    },
                    activeColor: Colors.red,
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              child: const Text("Apply", style: TextStyle( color: Colors.red),),
              onPressed: () {
                setState(() {}); // Apply the filter and rebuild
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

   Widget _buildSection(String title, List<String>? scannedItems, List<String>? favouritedItems, List<String>? sharedItems) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center( // Wrap the heading with Center to ensure it is centered
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min, // Ensure the row width fits the content
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 15, color: Colors.white),
                ),
                SizedBox(width: 12),
                const Icon(
                  Icons.trending_up_sharp,
                  size: 15,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 4.0),
        RankingCard(items: scannedItems, heading: "Most Scanned"),
        RankingCard(items: favouritedItems, heading: "Most Favourited"),
        RankingCard(items: sharedItems, heading: "Most Shared"),
        const SizedBox(height: 26.0),
      ],
    );
  }

  Future<AnalyticObject> _loadData() async {
    var session = userSession();
    String? email = session.userEmail;
    return await db.analytics(email);
  }
}
