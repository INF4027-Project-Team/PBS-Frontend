class AppProduct {
  final String name;
  final String price;
  final String imageUrl;
  final String category;
  final String brand;
  final String commissionRate;
  final String affiliate;
  final String webUrl;
  final String affiliateWebUrl;
  final String description;
  final String earningsPerClick;
  final String totalSalesVolume;
  final bool hasCouponsAvailable;
  final bool isTopRated;
  final bool isNew;
  final bool isPriority;
  final bool onSale;
  final bool onPromotion;

  AppProduct({
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.category,
    required this.brand,
    required this.commissionRate,
    required this.affiliate,
    required this.webUrl,
    required this.affiliateWebUrl,
    required this.description,
    required this.earningsPerClick,
    required this.totalSalesVolume,
    required this.hasCouponsAvailable,
    required this.isTopRated,
    required this.isNew,
    required this.isPriority,
    required this.onSale,
    required this.onPromotion,
  });

  factory AppProduct.fromJson(Map<String, dynamic> json) {
    return AppProduct(
      name: json['name'],
      price: json['price'],
      imageUrl: json['imageUrl'],
      category: json['category'],
      brand: json['brand'],
      commissionRate: json['commissionRate'],
      affiliate: json['affiliate'],
      webUrl: json['webUrl'],
      affiliateWebUrl: json['affiliateWebUrl'],
      description: json['description'],
      earningsPerClick: json['earningsPerClick'],
      totalSalesVolume: json['totalSalesVolume'],
      hasCouponsAvailable: json['hasCouponsAvailable'],
      isTopRated: json['isTopRated'],
      isNew: json['isNew'],
      isPriority: json['isPriority'],
      onSale: json['onSale'],
      onPromotion: json['onPromotion'],
    );
  }
}
