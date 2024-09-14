import 'package:flutter/material.dart';
import '/objects/history_item.dart';
import '../../../objects/Product.dart';
import 'package:shop_app/database%20access/database_service.dart';
import 'package:shop_app/screens/barcode_offers/offers_screen.dart';

class HistoryItemCard extends StatelessWidget {
  final HistoryItem item;

  const HistoryItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
              return const AlertDialog(
                  content: Row(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(width: 20),
                    Text('Loading Results...', style: TextStyle(fontSize: 13),),
                     ],
                    ),
                  );
                },
              );

        DatabaseService databaseService = DatabaseService();
        List<Product> offers = await databaseService.lookupBarcode(item.productBarcode);
        List<Product> specialOffers = databaseService.getSpecialOffers(offers);
        if (Navigator.of(context).canPop()) {
                    Navigator.of(context).pop();}
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductList(
              products: offers,
              barcodeValue: item.productBarcode,
              specialOffers: specialOffers,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        child: SizedBox(
          height: 90,
          child: Card(
            margin: const EdgeInsets.all(8),
            color: const Color(0xFFF5F6F9),
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Network image
                  Image.network(
                    item.photo,
                    height: 50,
                  ),
                  SizedBox(width: 10), // Space between image and text
                  // Column for title and other details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          item.name,
                          maxLines: 2,
                          style: const TextStyle(
                            fontSize: 11,
                          ),
                        ),
                        SizedBox(height: 5), // Space between title and other text
                        Text(
                          item.dateOfScan,
                          maxLines: 2,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        // Additional text/details can be added here
                      ],
                    ),
                  ),
                  // Cross button to delete the card
                  IconButton(
                    icon: Icon(Icons.close, size: 20, color: Colors.grey),
                    onPressed: () {
                      // Placeholder for delete functionality
                      print("Delete button pressed");
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
