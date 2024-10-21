import 'package:shop_app/screens/Dashboard/components/special_offers_card.dart';
import 'package:intl/intl.dart';

class Product {
  final String id;
  final String title;
  final String description;
  final double price;
  final String currency;
  final String imagePath;
  final String logoPath;
  final String category;
  final String brand;
  final double commission;  
  final String network;
  final String webLink;
  final String mostRecentDate;
  offerType specialtyType;
  bool isFavourite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.imagePath,
    required this.logoPath,
    required this.price,
    required this.currency,
    required this.category,
    required this.brand,
    required this.commission,
    required this.network,
    required this.webLink,
    required this.mostRecentDate,
    required this.specialtyType,
    required this.isFavourite,
  });

factory Product.fromJson( Map<String, dynamic> json ) {
    return Product(
      id: json['productID'] ?? "n/a",
      //imagePath: 'https://assets.mydeal.com.au/48517/lego-75387-star-wars-boarding-the-tantive-iv-11607678_00.jpg?v=638562396326161647&imgclass=dealgooglefeedimage',
      title: json['name'] ?? "n/a",
      description: json['description'] ?? "n/a",
      price: json['price']!= null ? double.parse(json['price']) : 100.0,
      currency: json['currency'] ?? "n/a",
      imagePath: json['imageURL'] ?? "https://media.istockphoto.com/id/1396814518/vector/image-coming-soon-no-photo-no-thumbnail-image-available-vector-illustration.jpg?s=2048x2048&w=is&k=20&c=b9S9F5NT9TWeFZE8XGGdIu3FucUa2Nm9MAXIgkj-FnA=",
      logoPath: json['logoUri'] ?? "https://media.istockphoto.com/id/1396814518/vector/image-coming-soon-no-photo-no-thumbnail-image-available-vector-illustration.jpg?s=2048x2048&w=is&k=20&c=b9S9F5NT9TWeFZE8XGGdIu3FucUa2Nm9MAXIgkj-FnA=",
      category: json['category'] ?? "n/a",
      brand: json['brand'] ?? "n/a",
      commission: json['commissionRate'] != null ? double.parse(json['commissionRate']) : 0.0,
      specialtyType: offerType.price,
      network: json['affiliate'] ?? "n/a",
      webLink: json['webURL'] ?? "https://media.istockphoto.com/id/1396814518/vector/image-coming-soon-no-photo-no-thumbnail-image-available-vector-illustration.jpg?s=2048x2048&w=is&k=20&c=b9S9F5NT9TWeFZE8XGGdIu3FucUa2Nm9MAXIgkj-FnA=",
      mostRecentDate: json['mostRecentDate'] ?? "n/a",
      isFavourite: false,
    );
  }
  


  // Function to calculate the average price of all products in the list
double averagePrice(List<Product> products) {
  if (products.isEmpty) {
    return 0.0;
  }
  double totalPrice = products.fold(0.0, (sum, product) => sum + product.price);
  return totalPrice / products.length;
}

// Function to calculate the average commission of all products in the list
double averageCommission(List<Product> products) {
  if (products.isEmpty) {
    return 0.0;
  }
  double totalCommission = products.fold(0.0, (sum, product) => sum + product.commission);
  return totalCommission / products.length;
}

// Function to calculate the average commission of all products in the list
double averagePayout(List<Product> products) {
  if (products.isEmpty) {
    return 0.0;
  }
  double totalPayout = products.fold(0.0, (sum, product) => sum +(product.price*(product.commission/100)));
  return totalPayout / products.length;
}

// Function to count the number of products with affiliate "impact.com" and "eBay"
Map<String, int> affiliateOfferCounts(List<Product> products) {
  int impactCount = 0;
  int ebayCount = 0;

  for (var product in products) {
    if (product.network == "Impact") {
      impactCount++;
    } else if (product.network == "eBay") {
      ebayCount++;
    }
  }

  return {
    "impact.com": impactCount,
    "eBay": ebayCount,
  };
}


// Function to calculate the average price of eBay and impact.com products separately
List<double> averageAffiliatePrice(List<Product> products) {
  double totalImpactPrice = 0.0;
  double totalEbayPrice = 0.0;
  int impactCount = 0;
  int ebayCount = 0;

  for (var product in products) {
    if (product.network == "Impact") {
      totalImpactPrice += product.price;
      impactCount++;
    } else if (product.network == "eBay") {
      totalEbayPrice += product.price;
      ebayCount++;
    }
  }

  return [impactCount > 0 ? totalImpactPrice / impactCount : 0.0,
    ebayCount > 0 ? totalEbayPrice / ebayCount : 0.0,
  ];
}


//Function to generate histogram data
List<double> prepareHistogramRange(List<Product> products) {
  if (products.isEmpty) {
    // Return a list of 5 zeros if input is null
    return List.generate(5, (_) => 0.0);
  }

  // Find the lowest and highest numbers in the list
  double minNumber = products.map((obj) => obj.price).reduce((a, b) => a < b ? a : b);
  double maxNumber = products.map((obj) => obj.price).reduce((a, b) => a > b ? a : b);

  // Create a list of 5 double values initialized to 0
  List<double> histogramCounts = List.generate(5, (_) => 0.0);

  // Calculate the range step based on 20% intervals
  double rangeStep = (maxNumber - minNumber) / 4;

  // Create 5 bins with evenly spaced ranges from the minNumber
  for (var offer in products) {
    double percentage = (offer.price - minNumber) / rangeStep;
    int index = (percentage ~/ 1).toInt(); // Each index represents 20% step

    if (index >= 5) {
      index = 4;
    }

    // Increment the count for the corresponding category
    histogramCounts[index] += 1;
  }

  return histogramCounts;
}


//Histogram X axis labels
List<String> histogramXAxis(List<Product> products) {
  if (products.isEmpty) {
    // Return a list of 5 "0.0" strings if input is empty
    return List.generate(5, (_) => "0.0");
  }

  // Find the lowest and highest numbers in the list
  double minNumber = products.map((obj) => obj.price).reduce((a, b) => a < b ? a : b);
  double maxNumber = products.map((obj) => obj.price).reduce((a, b) => a > b ? a : b);

  // Calculate the step size, evenly spaced between the smallest and largest price
  double rangeStep = (maxNumber - minNumber) / 4;

  // Generate a list of 5 strings, each representing a price range
  List<String> priceRange = List.generate(5, (index) => (minNumber + index * rangeStep).toStringAsFixed(2));

  return priceRange;
}


// Function to calculate the average commission of eBay and impact.com products separately
List<double> averageAffiliateComissions(List<Product> products) {
  double totalImpactCommission = 0.0;
  double totalEbayCommission = 0.0;
  int impactCount = 0;
  int ebayCount = 0;

  for (var product in products) {
    if (product.network == "Impact") {
      totalImpactCommission += product.commission;
      impactCount++;
    } else if (product.network == "eBay") {
      totalEbayCommission += product.commission;
      ebayCount++;
    }
  }
    return [
     impactCount > 0 ? totalImpactCommission / impactCount : 0.0,
     ebayCount > 0 ? totalEbayCommission / ebayCount : 0.0,
    ];
  }
  String dateFormatter()
  {
      DateTime dateTime = DateTime.parse(mostRecentDate);

      DateFormat formatter = DateFormat('dd MMM yyyy');

      return formatter.format(dateTime);
  }


   Map<String, dynamic> toJson() {
    return {
        'productID': id,
       'name': title,
       'description':description,
       'price':price,
     'currency': currency,
     'imageURL': imagePath,
      'category':category,
      'brand':brand,
      'commissionRate':commission,
      'affiliate':network,
    };
  }
  
  
// Copy constructor
  Product.copy(Product original)
      : id = original.id,
        title = original.title,
        description = original.description,
        price = original.price,
        currency=original.currency,
        imagePath=original.imagePath,
        logoPath= original.logoPath,
        category =  original.category,
        brand = original.brand,
        commission = original.commission,
        specialtyType = original.specialtyType,
        network = original.network,
        webLink = original.webLink,
        mostRecentDate = original.mostRecentDate,
        isFavourite = original.isFavourite;


@override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Product) return false;
    return other.title == title && other.description == description && other.price == price && other.currency == currency && other.commission == commission && other.network == network;
  }

  @override
  int get hashCode => title.hashCode ^ description.hashCode ^ price.hashCode ^ currency.hashCode ^ commission.hashCode ^ network.hashCode;


}

List<Product> demoProducts = [
  Product(
    id: 'sfsfsf',
    title: "LEGO Star Wars: Captain Rex Y-Wing Microfighter - (75391)",
    imagePath: "https://www.bigw.com.au/medias/sys_master/images/images/h08/h51/49514013425694.jpg",
    logoPath: "https://www.bigw.com.au/medias/sys_master/images/images/h08/h51/49514013425694.jpg",
    price: 64.99,
    description: "Let kids team up with a popular Star Wars: The Clone Wars character on playtime missions with this LEGO? brick-built Captain Rex Y-Wing Microfighter (75391) starship toy. A fun fantasy gift idea for creative boys  girls and any young fan aged 6 and up  this buildable vehicle toy playset features the first-ever LEGO Star Wars? construction model of Captain Rex?s Y-wing. Designed to be easy to build so the action starts fast  this miniature version of the iconic Star Wars starfighter has a minifigure cockpit and 2 stud shooters  and the included Captain Rex LEGO minifigure comes with 2 blasters. Add another dimension to your child?s creative experience with the LEGO Builder app  featuring instructions and digital zoom and rotate viewing tools to help them build with confidence. This small set is part of a fun collectible series of quick-build LEGO Star Wars Microfighters (sold separately)  which can be matched up for even more brick-built action-adventures.",
    currency:"USD",
    brand:"LEGO",
    commission:1.23,
    category:"Toys", 
    network:"impact.com",
    webLink: "www.bots.com",
    mostRecentDate: "@020",
    specialtyType: offerType.price,
    isFavourite: true,
  ),

  
  ];