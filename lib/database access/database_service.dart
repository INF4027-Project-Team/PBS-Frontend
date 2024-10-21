import 'package:shop_app/objects/AnalyticObject.dart';
import '../objects/Product.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '/objects/history_item.dart'; 
import 'dart:async';

class DatabaseService {
  
  // Adrian UCT http://196.24.155.150:8080
  //Ahmed home http://192.168.1.149:8080
  final String baseUrl = 'http://192.168.1.149:8080'; 
  bool _isRequestInProgress = false;



  //Retrieve barcode results
  Future<List<Product>> lookupBarcode(String? stringToSend) async {
    final String url = '$baseUrl/barcode'; 
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
    final String url = '$baseUrl/name'; 
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



  //Recieve instagram AI caption
  Future<String> getAICaption(Product product, String suffix) async {
    String productJson = jsonEncode(product.toJson());
    final String url = '$baseUrl$suffix';

    var urlu = Uri.parse(url);
    final Map<String, String> headers = {"Content-Type": "application/json"};

    final response = await http.post(
      urlu,
      headers: headers,
      body: productJson,
      
    );
    print(response.body);
    if (response.statusCode == 200) 
    {
      return response.body;
    } 
    else 
    {
      return "Here is a nice product";
    }
  }



  //Recieve caption for recommended product
  Future<String> getRecommendedCaption(Product product) async {
    String productJson = jsonEncode(product.toJson());
    final String url = '$baseUrl/generateCaptionForProductComparison';

    var urlu = Uri.parse(url);
    final Map<String, String> headers = {"Content-Type": "application/json"};

    final response = await http.post(
      urlu,
      headers: headers,
      body: productJson,
      
    );

    if (response.statusCode == 200) 
    {
      return response.body;
    } 
    else 
    {
      return "Here is a nice product";
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



  //Add impact API
  Future<void> addImpactKeys(String? email, String? username, String? password, String? key) async {
   
    final String url = '$baseUrl/updateAPIKeys';

    var urlu = Uri.parse('$url?email=$email&impactUsername=$username&impactPassword=$password&ebayKey=$key');
    final Map<String, String> headers = {"Content-Type": "application/json"};

    final response = await http.post(
      urlu,
      headers: headers,
      body: " ",
      
    );

    if (response.statusCode == 200) 
    {
      print('Keys added successfully');
    } 
    else 
    {
      print('Keys Not Added: ${response.statusCode}');
    }
  }



  //Add eBay keys
  Future<void> addEbayKeys(String? email, String? key) async {
   
    final String url = '$baseUrl/updateAPIKeys';

    var urlu = Uri.parse('$url?email=$email&ebayKey=$key');
    final Map<String, String> headers = {"Content-Type": "application/json"};

    final response = await http.post(
      urlu,
      headers: headers,
      body: " ",
      
    );

    if (response.statusCode == 200) 
    {
      print('Keys added successfully');
    } 
    else 
    {
      print('Keys Not Added: ${response.statusCode}');
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



  //Add a barcode scan record to the database
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



  //User Scan count
  Future<String> userScanCount(String? email) async 
  {
    while (_isRequestInProgress) {
      await Future.delayed(const Duration(milliseconds: 100)); // Wait for a bit
    }
    
    _isRequestInProgress = true;

    final String url = '$baseUrl/creatorscancount';
    var urlu = Uri.parse('$url?email=$email');
    final Map<String, String> headers = {"Content-Type": "application/json"};
 
    final response = await http.post(
      urlu,
      headers: headers,
      body: " ",
    );

    _isRequestInProgress = false;
    return response.body;
  }


  //User share count
  Future<String> userShareCount(String? email) async 
  {
    while (_isRequestInProgress) {
      await Future.delayed(const Duration(milliseconds: 100)); // Wait for a bit
    }
    _isRequestInProgress = true;

    final String url = '$baseUrl/creatorsharecount';
    var urlu = Uri.parse('$url?email=$email');
    final Map<String, String> headers = {"Content-Type": "application/json"};
 
    final response = await http.post(
      urlu,
      headers: headers,
      body: " ",
    );

    _isRequestInProgress = false;
    return response.body;
  }



  //Product favourite count
  Future<String> productFavouriteCount(String? productID) async 
  {

    final String url = '$baseUrl/productfavoritecount';
    var urlu = Uri.parse('$url?productID=$productID');
    final Map<String, String> headers = {"Content-Type": "application/json"};
 
    final response = await http.post(
      urlu,
      headers: headers,
      body: " ",
    );

    String answer = response.body;
    
    return answer;
  }



  //Product Share count
  Future<String> productShareCount(String? productID) async 
  {
    final String url = '$baseUrl/productsharecount';
    var urlu = Uri.parse('$url?productID=$productID');
    final Map<String, String> headers = {"Content-Type": "application/json"};
 
    final response = await http.post(
      urlu,
      headers: headers,
      body: " ",
    );

    String answer = response.body;
    return answer;
  }



  //Fetch analytics data from backend
  Future<AnalyticObject> analytics(String? email) async 
  {

    final String url = '$baseUrl/analytics';
    var urlu = Uri.parse('$url?email=$email');
    final Map<String, String> headers = {"Content-Type": "application/json"};
 
    final response = await http.post(
      urlu,
      headers: headers,
      body: " ",
    );

      String reply = response.body.replaceAll('"null"', '"Ape"').replaceAll('null', '"Ape"');
      Map<String, dynamic> analyticsData = jsonDecode(reply);
      AnalyticObject results = AnalyticObject.fromJson(analyticsData);
      if (results.sharedBrands!.length < 5) {
    results.sharedBrands?.add('Product'); 
  }

  if (results.sharedCategories!.length < 5) {
    results.sharedCategories?.add('Product'); 
  }
      return results;
  }


  }


