import 'package:flutter/material.dart';
import 'package:pbs/src/screens/view_product_information.dart';
import 'package:pbs/src/objects/product.dart';  // Assuming this is the correct import path

class ProductDisplayCard extends StatelessWidget {
  final Product item;

  const ProductDisplayCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ResultsScreen(product: item)),
        );
      },
      child: Card(
        margin: const EdgeInsets.all(8),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              Image.network(item.imagePath, width: 70),
              SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Price: \$${item.price.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 18, color: Colors.black),
                    ),
                    Text(
                      'Commission: ${item.commission.toStringAsFixed(2)}%',
                      style: const TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}