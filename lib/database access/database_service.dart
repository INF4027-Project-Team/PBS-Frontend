import '../objects/Product.dart';// Assuming you have a Product class defined
import 'dart:convert';
import 'package:http/http.dart' as http;
import '/objects/history_item.dart'; 
import 'dart:async';

class DatabaseService {
  
  final String baseUrl = 'http://192.168.1.149:8080'; // Replace with your server's IP address


  //Retrieve barcode results
  Future<List<Product>> lookupBarcode(String? stringToSend) async {
    const url = 'http://192.168.1.149:8080/barcode'; 
    final response = await http.post(
      Uri.parse(url),
      body: stringToSend,
    );
    
    if (response.statusCode == 200) 
    {
      List<dynamic> offers = jsonDecode(response.body);
      List<Product> offersList = offers.map((jsonItem) => Product.fromJson( jsonItem)).toList();
 
      return offersList;      
    } 
    else
    {
      return [];
    }
  }


  //Retrieve keyword search results
  Future<List<Product>> lookupItem(String? stringToSend) async {
    const url = 'http://192.168.1.149:8080/name'; 
    final response = await http.post(
      Uri.parse(url),
      body: stringToSend,
    );
    
    if (response.statusCode == 200) 
    {
      List<dynamic> offers = jsonDecode(response.body);
      List<Product> offersList = offers.map((jsonItem) => Product.fromJson( jsonItem)).toList();
 
      return offersList;      
    } 
    else
    {
      return [];
    }
  }


  //Get list of highlighted offers
  List<Product> getSpecialOffers(List<Product> offersList)
  {

    //Identify best offer
    Product bestOffer = offersList[0];

    //Identify best price
    Product lowestPricedOffer = offersList[0];
    for (var offer in offersList) 
    {
      if (offer.price < lowestPricedOffer.price) 
      {
        lowestPricedOffer = offer;
      }
    }

    //Identify best commission
    Product bestCommissionOffer = offersList[0];
    for (var offer in offersList) 
    {
      if (offer.commission > bestCommissionOffer.commission) 
      {
        bestCommissionOffer = offer;
      }
    }

    List<Product> specialOffers =[bestOffer,lowestPricedOffer,bestCommissionOffer];
    
    return specialOffers;
  }



  List<Product> placeSpecialOffersFirst(List<Product> offersList, List<Product> specialOffersList) {
  // Create a set of special offers for quick lookup
  Set<Product> specialOffersSet = Set.from(specialOffersList);
  
  // Create a list for special offers and another for the rest
  List<Product> specialOffers = [];
  List<Product> regularOffers = [];
  
  // Separate offersList into special offers and regular offers
  for (var offer in offersList) {
    if (specialOffersSet.contains(offer)) {
      specialOffers.add(offer);
    } else {
      regularOffers.add(offer);
    }
  }
  
  // Combine the special offers and regular offers
  return specialOffers + regularOffers;
}


  //Retrieve user favourates
  Future<List<Product>> getFavouriteFromDatabase(String? email) async {
    String action = "get";
    final String url = '$baseUrl/favorites';

    var urlu = Uri.parse('$url?email=$email&action=$action');
    final response = await http.post(
      urlu,
      headers: 
      {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>
      {
        'productJson': 'none',
      }),
    );

    if (response.statusCode == 200) 
    {
      List<dynamic> offers = jsonDecode(response.body);
      List<Product> favourites = offers.map((jsonItem) => Product.fromJson(jsonItem)).toList();
    
      return favourites;
    }
    else 
    {
      return [];
    }
    
  }

  //Add new item to favourates
  Future<void> addFavouriteToDatabase(String? email, Product product) async {
    String productJson = jsonEncode(product.toJson());
    String action = "add";
    final String url = '$baseUrl/favorites';

    var urlu = Uri.parse('$url?email=$email&action=$action&productJson=$productJson');
    final Map<String, String> headers = {"Content-Type": "application/json"};

    final response = await http.post(
      urlu,
      headers: headers,
      body: " ",
      
    );

    if (response.statusCode == 200) 
    {
      print('Favorite added successfully');
    } 
    else 
    {
      print('Failed to add favorite: ${response.statusCode}');
    }
  }


  //Retrieve user scan history
  Future<List<HistoryItem>> getHistoryFromDatabase(String? email) async {
    String action = "get";
    final String url = '$baseUrl/history';
    String barcode = "";
    var urlu = Uri.parse('$url?email=$email&action=$action&barcode=$barcode');
    final response = await http.post(
      urlu,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'barcode': 'none',
      }),
    );


    if (response.statusCode == 200) {
      List<dynamic> results = jsonDecode(response.body);
      print(results);
      List<HistoryItem> history = results.map((jsonItem) => HistoryItem.fromJson(jsonItem)).toList();
    
      return history;
    }
    else {
      return [];
      }
    
  }


  Future<void> addHistoryToDatabase(String? email, HistoryItem item) async {
    String barcode = item.productBarcode;
    String name = item.name;
    String photo = item.photo;
    String action = "add";
    final String url = '$baseUrl/history';
    var urlu = Uri.parse('$url?email=$email&action=$action&barcode=$barcode&name=$name&photo=$photo');
    final Map<String, String> headers = {"Content-Type": "application/json"};

    final response = await http.post(
      urlu,
      headers: headers,
      body: " ",
      
    );

    if (response.statusCode == 200) 
    {
      print('History added successfully');
    } 
    else 
    {
      print('Failed to add history: ${response.statusCode}');
    }
  }


    //Create User Account
    Future<bool> userSignUp(String? email, String? password, String? name, String? surname) async {
   
    final String url = '$baseUrl/signup';
    var urlu = Uri.parse('$url?email=$email&password=$password&firstName=$name&surname=$surname');
    final Map<String, String> headers = {"Content-Type": "application/json"};

    final response = await http.post(
      urlu,
      headers: headers,
      body: " ",
      
    );

    String answer = response.body;

    if (response.statusCode == 200) 
    {
      if (answer== "Account created")
      {
        return true;
      }
      else
      {
        return false;
      }
    } 
    else 
    {
      return false;
    }
  }


  //Allow user to sign in to existing account
  Future<bool> userSignIn(String? email, String? password) async 
  {
    final String url = '$baseUrl/signin';
    var urlu = Uri.parse('$url?email=$email&password=$password');
    final Map<String, String> headers = {"Content-Type": "application/json"};
 
    final response = await http.post(
      urlu,
      headers: headers,
      body: " ",
    );

    String answer = response.body;

    print(answer);

    if (response.statusCode == 200) 
    {
      if (answer== "Success")
      {
        return true;
      }
      else
      {
        return false;
      }
    } 
    else 
    {
      return false;
    }
  }


  }


