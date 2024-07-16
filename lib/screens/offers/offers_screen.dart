import 'package:flutter/material.dart';
import '../../objects/product.dart'; 
import 'components/product_display_card.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductList extends StatefulWidget {
  final List<Product> products;
  final List<Product> specialOffers;
  final String barcodeValue;

  const ProductList({
    Key? key,
    required this.products,
    required this.specialOffers,
    required this.barcodeValue,
  }) : super(key: key);

  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  late List<Product> _currentProducts;
  late List<Product> _specialProducts;
  String _selectedSort = 'Value'; // State variable for dropdown value

  @override
  void initState() {
    super.initState();
    _currentProducts = widget.products;
    _specialProducts = widget.specialOffers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  'Scan Results',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Image.network(
                  _currentProducts.isNotEmpty ? _currentProducts[0].imagePath : '',
                  height: 190,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  'Offers for \n${widget.products[0].title}',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  const Text(
                    'Sort By: ',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 20.0),
                  DropdownButton<String>(
                    value: _selectedSort, // use the state variable
                    icon: const Icon(Icons.arrow_downward),
                    elevation: 16,
                    style: const TextStyle(color: Colors.black),
                    underline: Container(
                      height: 2,
                      color: Colors.deepPurpleAccent,
                    ),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _selectedSort = newValue; // update the state variable
                        });
                        _handleSorting(newValue);
                      }
                    },
                    items: <String>[
                      'Value',
                      'Price',
                      'Commission',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    dropdownColor: const Color(0xFFF5F6F9),
                  ),
                ],
              ),
            ),
            ..._currentProducts.map((p) => ProductDisplayCard(item: p, specialOffers: _specialProducts,)).toList(),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSorting(String newValue) async {
    List<Product> sortedProducts = [];

    if (newValue == 'Price') {
      sortedProducts = await postToBackend(widget.barcodeValue, "price");
    } else if (newValue == 'Commission') {
      sortedProducts = await postToBackend(widget.barcodeValue, "commission");
      print(_currentProducts);
    } else if (newValue == 'Value') {
      sortedProducts = await postToBackend(widget.barcodeValue, "value");
    }

    setState(() {
      _currentProducts = sortedProducts;
    });
  }

  Future<List<Product>> postToBackend(String? stringToSend, String sortAttribute) async {
    const baseUrl = 'http://192.168.1.149:8080/barcode'; // Change to your server's IP address
    var url = Uri.parse('$baseUrl?sortAttribute=$sortAttribute');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: stringToSend,
    );

    List<Product> offersList = [];

    if (response.statusCode == 200) {
      List<dynamic> offers = jsonDecode(response.body);
      offersList = offers.map((jsonItem) => Product.fromJson(jsonItem)).toList();
    }

    return offersList;
  }
}
