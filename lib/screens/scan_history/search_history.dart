import 'package:flutter/material.dart';
import 'package:shop_app/objects/User.dart';
import '/objects/history_item.dart';
import 'package:shop_app/screens/scan_history/components/history_card.dart';
import 'package:shop_app/database%20access/database_service.dart';

class SearchHistoryScreen extends StatefulWidget {
  static String routeName = "/searchHistory";
  SearchHistoryScreen({super.key});

  @override
  _SearchHistoryScreenState createState() => _SearchHistoryScreenState();
}

class _SearchHistoryScreenState extends State<SearchHistoryScreen> {
  late Future<List<HistoryItem>> _demoProductsFuture;
  List<HistoryItem> historyList = [];
  List<HistoryItem> displayedHistory = [];
  bool showLastMonth = false;
  bool showAllRemaining = false;
  bool lastWeekEmpty = false;
  bool lastMonthEmpty = false;

  @override
  void initState() {
    super.initState();
    _demoProductsFuture = getProducts();
  }

  Future<List<HistoryItem>> getProducts() async {
    var session = userSession();
    String? email = session.userEmail;
    DatabaseService _databaseService = DatabaseService();
    historyList = await _databaseService.getHistoryFromDatabase(email);

    filterItems(); // Filter the items after fetching
    return historyList;
  }

  void filterItems() {
    DateTime now = DateTime.now();
    DateTime lastWeek = now.subtract(Duration(days: 7));

    // Filter for last week's items
    displayedHistory = historyList
        .where((item) => item.dateOfScan != null && DateTime.parse(item.dateOfScan).isAfter(lastWeek))
        .toList();

    if (displayedHistory.isEmpty) {
      lastWeekEmpty = true;
      loadLastMonth(); // Automatically load last month if last week is empty
    }

    setState(() {});
  }

  void loadLastMonth() {
    DateTime now = DateTime.now();
    DateTime lastMonth = now.subtract(Duration(days: 30));
    DateTime lastWeek = now.subtract(Duration(days: 7));

    // Add last month's items
    List<HistoryItem> lastMonthItems = historyList
        .where((item) => item.dateOfScan != null && DateTime.parse(item.dateOfScan).isAfter(lastMonth) && DateTime.parse(item.dateOfScan).isBefore(lastWeek))
        .toList();

    if (lastMonthItems.isEmpty) {
      lastMonthEmpty = true;
    } else {
      displayedHistory.addAll(lastMonthItems);
    }

    showLastMonth = true;
    setState(() {});
  }

  void loadAllRemaining() {
    // Add remaining items (older than a month)
    List<HistoryItem> remainingItems = historyList
        .where((item) => item.dateOfScan != null && DateTime.parse(item.dateOfScan).isBefore(DateTime.now().subtract(Duration(days: 30))))
        .toList();

    displayedHistory.addAll(remainingItems);

    lastMonthEmpty = true;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Scan History',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        backgroundColor: Colors.white,
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
          Expanded(
            child: FutureBuilder<List<HistoryItem>>(
              future: _demoProductsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text('No scan history available');
                } else {
                  return ListView.builder(
                    itemCount: displayedHistory.length + 1, // Add 1 for the button
                    itemBuilder: (context, index) {
                      if (index < displayedHistory.length) {
                        return HistoryItemCard(item: displayedHistory[index]);
                      } else {
                        // Define buttonWidget to handle conditional display
                        Widget? buttonWidget;

                        if (showLastMonth && !lastWeekEmpty &&!lastMonthEmpty) {
                          buttonWidget = SizedBox(
                            height: 40,
                            child: ElevatedButton(
                              onPressed: loadLastMonth,
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(horizontal: 24),
                                minimumSize: Size(40, 30), // Make the button smaller
                              ),
                              child: Text('Load Last Month'),
                            ),
                          );
                        } else if (!showLastMonth && showAllRemaining && !lastMonthEmpty) {
                          buttonWidget = SizedBox(
                            height: 40,
                            child: ElevatedButton(
                              onPressed: loadAllRemaining,
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(horizontal: 24),
                                minimumSize: Size(40, 30), // Make the button smaller
                              ),
                              child: Text('Load All Remaining'),
                            ),
                          );
                        }

                        return Column(
                          children: [
                            const SizedBox(height: 5,),
                            if (buttonWidget != null) buttonWidget,
                            const SizedBox(height: 5,),
                          ],
                        );
                      }
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
