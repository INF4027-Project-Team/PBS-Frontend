class Product {
  final String name;
  final double price;
  final String imagePath;
  final String category;
  final String brand;
  final double commission;  
  final String network;
  Product({
    required this.name,
    required this.imagePath,
    required this.price,
    required this.category,
    required this.brand,
    required this.commission,
    required this.network,
  });

factory Product.fromJson(String networkName, Map<String, dynamic> json ) {
    return Product(
      name: json['name'],
      price: double.parse(json['price']),
      imagePath: json['imageURL'],
      category: json['category'],
      brand: json['brand'],
      commission: double.parse(json['commissionRate']),
      network: networkName,
    );
  }

}