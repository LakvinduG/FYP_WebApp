// lib/models/product.dart
class Product {
  final int id;
  final int companyId;
  final String name;
  final String brandName;
  final String category;
  final String subCategory;
  final String nutritionalInfo;
  final String ingredients;
  final String storageInstruction;
  final double price;
  final List<String> keywords;
  final String additionalInfo;

  Product({
    required this.id,
    required this.companyId,
    required this.name,
    required this.brandName,
    required this.category,
    required this.subCategory,
    required this.nutritionalInfo,
    required this.ingredients,
    required this.storageInstruction,
    required this.price,
    required this.keywords,
    required this.additionalInfo,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      companyId: json['companyId'],
      name: json['name'] ?? '',
      brandName: json['brandName'] ?? '',
      category: json['category'] ?? '',
      subCategory: json['subCategory'] ?? '',
      nutritionalInfo: json['nutritionalInfo'] ?? '',
      ingredients: json['ingredients'] ?? '',
      storageInstruction: json['storageInstruction'] ?? '',
      price: (json['price'] as num).toDouble(),
      keywords: json['keywords'] != null
          ? List<String>.from(json['keywords'])
          : [],
      additionalInfo: json['additionalInfo'] ?? '',
    );
  }
}
