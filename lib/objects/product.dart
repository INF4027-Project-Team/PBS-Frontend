import 'package:shop_app/screens/Dashboard/components/special_offers_card.dart';

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
    required this.specialtyType,
    required this.isFavourite,
  });

factory Product.fromJson( Map<String, dynamic> json ) {
    return Product(
      id: json['productID'],
      //imagePath: 'https://assets.mydeal.com.au/48517/lego-75387-star-wars-boarding-the-tantive-iv-11607678_00.jpg?v=638562396326161647&imgclass=dealgooglefeedimage',
      title: json['name'],
      description: json['description'],
      price: double.parse(json['price']),
      currency: json['currency'],
      imagePath: json['imageURL'],
      logoPath: json['logoUri'],
      category: json['category'],
      brand: json['brand'],
      commission: double.parse(json['commissionRate']),
      specialtyType: offerType.price,
      network: json['affiliate'],
      isFavourite: false,
    );
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
    specialtyType: offerType.price,
    isFavourite: true,
  ),

  
  ];