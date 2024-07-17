import 'package:flutter/material.dart';
import 'package:shop_app/components/product_card.dart';
import '/objects/product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../product_details/product_details_screen.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                itemCount: demoProducts.length,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio: 0.63, // Adjusted from 0.7 to 0.63
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 16,
                ),
                itemBuilder: (context, index) => ProductCard(
                  product: demoProducts[index],
                  onPress: () => Navigator.pushNamed(
                    context,
                    DetailsScreen.routeName,
                    //arguments:
                      //  ProductDetailsArguments(product: demoProducts[index]),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }



  Future<List<Product>> getFavouriteFromDatabase(String? stringToSend, String email, String productJson) async {
    final url = Uri.parse('http://192.168.1.149:8080/favorites'); // Change to your server's IP address
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
      'email': email,
      'action': "get",
      'productJson': productJson,
    }),
    );

    List<Product> favourites = [];

    if (response.statusCode == 200) {
      List<dynamic> offers = jsonDecode(response.body);
      favourites = offers.map((jsonItem) => Product.fromJson(jsonItem)).toList();
    }

    return favourites;
  }


}
