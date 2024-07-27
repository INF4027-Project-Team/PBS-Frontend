class HistoryItem {
final String scanID, creatorID, productBarcode, dateOfScan, name, photo;

  HistoryItem({
    required this.scanID,
    required this.creatorID,
    required this.productBarcode,
    required this.dateOfScan,
    required this.name,
    required this.photo,
  });

factory HistoryItem.fromJson( Map<String, dynamic> json ) {
    return HistoryItem(
      scanID: json['scanID'],
      creatorID: json['creatorID'],
      productBarcode: json['productBarcode'],
      dateOfScan: json['dateOfScan'],
      name: json['name'],
      photo: json['photo'],
    );
  }


   Map<String, dynamic> toJson() {
    return {
        'scanID': scanID,
       'creatorID': creatorID,
       'productBarcode':productBarcode,
       'dateOfScan':dateOfScan,
     'name': name,
     'photo': photo,
    };
  }
  
}