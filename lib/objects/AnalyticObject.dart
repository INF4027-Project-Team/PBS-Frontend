class AnalyticObject {
  String? totalScans;
  String? totalShares;
  List<String>? scannedProducts;
  List<String>? favourateProducts;
  List<String>? sharedProducts;
  List<String>? scannedBrands;
  List<String>? favouriteBrands;
  List<String>? sharedBrands;
  List<String>? scannedCategories;
  List<String>? favourateCategories;
  List<String>? sharedCategories;

  AnalyticObject({
    this.totalScans,
    this.totalShares,
    this.scannedProducts,
    this.favourateProducts,
    this.sharedProducts,
    this.scannedBrands,
    this.favouriteBrands,
    this.sharedBrands,
    this.scannedCategories,
    this.favourateCategories,
    this.sharedCategories,
  });

  factory AnalyticObject.fromJson( Map<String, dynamic> json ) {
    return AnalyticObject(
      totalScans: json['totalScans'] ?? "n/a",
      totalShares: json['totalShares'] ?? "n/a",
      scannedProducts: List<String>.from(json['scannedProducts']),
      favourateProducts: List<String>.from(json['favourateProducts']),
      sharedProducts: List<String>.from(json['sharedProducts']),
      scannedBrands: List<String>.from(json['scannedBrands']),
      favouriteBrands: List<String>.from(json['favouriteBrands']),
      sharedBrands: List<String>.from(json['sharedBrands']),
      scannedCategories: List<String>.from(json['scannedCategories'] ?? "n/a"),
      favourateCategories: List<String>.from(json['favourateCategories'] ?? "n/a"),
      sharedCategories: List<String>.from(json['sharedCategories'] ?? "n/a"),
    );
  }



}
