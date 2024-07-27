import 'package:flutter/material.dart';
import 'package:shop_app/components/product_card.dart';
import 'package:shop_app/database%20access/database_service.dart';
import 'package:shop_app/objects/User.dart';
import '../../objects/Product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../product_details/product_details_screen.dart';

class FavoriteScreen extends StatelessWidget {
  FavoriteScreen({Key? key}) : super(key: key);

  // Initialize favLength with null initially
  int? favLength;
  //DatabaseService data = DatabaseService();
  //Future<List<Product>> fav = data.getFavouriteFromDatabase("bots");

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Product>>(
      future: getFavourites(),//getFavourites(), // Call getFavourites method here
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error loading data'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No favorites found'));
        } else {
          // Data loaded successfully
          List<Product> prodList = snapshot.data!;
          favLength = prodList.length; // Update favLength with the length of the list

          return SafeArea(
            child: Column(
              children: [
                Text(
                  "Favourites",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: GridView.builder(
                      itemCount: favLength,
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 200,
                        childAspectRatio: 0.63,
                        mainAxisSpacing: 20,
                        crossAxisSpacing: 16,
                      ),
                      itemBuilder: (context, index) => ProductCard(
                        product: prodList[index], // Use prodList instead of demoProducts
                        onPress: () => Navigator.pushNamed(
                          context,
                          DetailsScreen.routeName,
                          //arguments:
                          //  ProductDetailsArguments(product: prodList[index]),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Future<List<Product>> getFavourites() async {
    var session = userSession();
    String? email = session.userEmail;
    DatabaseService _databaseService = DatabaseService();
    List<Product> favList = await _databaseService.getFavouriteFromDatabase(email);
    return favList;
  }

 

}
