import 'package:flutter/material.dart';
import 'package:shop_app/objects/User.dart';
import '/objects/history_item.dart'; 
import 'package:shop_app/screens/scan_history/components/history_card.dart';
import 'package:shop_app/database%20access/database_service.dart';
//import '../product_details/product_details_screen.dart';

class SearchHistoryScreen extends StatefulWidget {
  static String routeName = "/searchHistory";
  SearchHistoryScreen({super.key});

  @override
  _SearchHistoryScreenState createState() => _SearchHistoryScreenState();
}

class _SearchHistoryScreenState extends State<SearchHistoryScreen> {
  late Future<List<HistoryItem>> _demoProductsFuture;

  @override
  void initState() {
    super.initState();
    _demoProductsFuture = getProducts();
  }

  Future<List<HistoryItem>> getProducts() async {
    var session = userSession();
    String? email = session.userEmail;
    DatabaseService _databaseService = DatabaseService();
    List<HistoryItem> historyList = await _databaseService.getHistoryFromDatabase(email);
    return historyList;
  }
    
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Scan History', 
        style: Theme.of(context).textTheme.titleLarge,),
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
          FutureBuilder<List<HistoryItem>>(
            future: _demoProductsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Text('No scan history available');
              } else {
                return Column(
                  children: snapshot.data!
                      .map((product) => HistoryItemCard(item: product))
                      .toList(),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
