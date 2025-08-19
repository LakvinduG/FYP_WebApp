// lib/model/batch.dart
class Batch {
  final int? productId;
  final String? batchNo;
  final String? manufacturingDate;
  final String? expireDate;
  final int? batchQuantity;
  final String? manufacturerUsername;
  final String? manufacturerRole;
  final String? manufacturedId;
  final dynamic code;

  Batch({
    this.productId,
    this.batchNo,
    this.manufacturingDate,
    this.expireDate,
    this.batchQuantity,
    this.manufacturerUsername,
    this.manufacturerRole,
    this.manufacturedId,
    this.code,
  });

  factory Batch.fromJson(Map<String, dynamic> json) {
    return Batch(
      productId: json['productId'] != null ? int.tryParse(json['productId'].toString()) : null,
      batchNo: json['batchNo'],
      manufacturingDate: json['manufacturingDate'],
      expireDate: json['expireDate'],
      batchQuantity: json['batchQuantity'] != null ? int.tryParse(json['batchQuantity'].toString()) : null,
      manufacturerUsername: json['manufacturerUsername'],
      manufacturerRole: json['manufacturerRole'],
      manufacturedId: json['manufacturedId']?.toString(),
      code: json['code'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "productId": productId,
      "batchNo": batchNo,
      "manufacturingDate": manufacturingDate,
      "expireDate": expireDate,
      "batchQuantity": batchQuantity,
      "manufacturerUsername": manufacturerUsername,
      "manufacturerRole": manufacturerRole,
      "manufacturedId": manufacturedId,
      "code": code,
    };
  }
}
