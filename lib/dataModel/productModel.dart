import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String productId;
  final String productName;
  final DateTime launchDate;
  final String productStatus;
  final double cost;
  final String functionality;
  final String model;
  final String marketDemand;
  final String projectId; 

  ProductModel({
    required this.productId,
    required this.productName,
    required this.launchDate,
    required this.productStatus,
    required this.cost,
    required this.functionality,
    required this.model,
    required this.marketDemand,
    required this.projectId,
  });

  factory ProductModel.fromDocument(DocumentSnapshot<Map<String, dynamic>> doc) {
    var data = doc.data()!;
    return ProductModel(
      productId: doc.id,
      productName: data['productName'] as String,
      launchDate: (data['launchDate'] as Timestamp).toDate(),
      productStatus: data['productStatus'] as String,
      cost: data['cost'] as double,
      functionality: data['functionality'] as String,
      model: data['model'] as String,
      marketDemand: data['marketDemand'] as String,
      projectId: data['projectId'] as String,
    );
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      productId: json['productId'] as String,
      productName: json['productName'] as String,
      launchDate: DateTime.parse(json['launchDate'] as String),
      productStatus: json['productStatus'] as String,
      cost: json['cost'] as double,
      functionality: json['functionality'] as String,
      model: json['model'] as String,
      marketDemand: json['marketDemand'] as String,
      projectId: json['projectId'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': productName,
      'launchDate': Timestamp.fromDate(launchDate),
      'productStatus': productStatus,
      'cost': cost,
      'functionality': functionality,
      'model': model,
      'marketDemand': marketDemand,
      'projectId': projectId,
    };
  }

  static String? validateProductId(String value) {
    final pattern = RegExp(r'^[a-zA-Z0-9]{10,}$');
    if (value.isEmpty) {
      return 'Product ID cannot be empty';
    } else if (!pattern.hasMatch(value) || !RegExp(r'\d{3,}').hasMatch(value)) {
      return 'Product ID must contain only a-z, at least 3 numbers, and be 10 characters long';
    }
    return null;
  }

  static String? validateProductName(String value) {
    if (value.isEmpty) {
      return 'Product name cannot be empty';
    } else if (value.length > 255) {
      return 'Product name cannot exceed 255 characters';
    }
    return null;
  }
}
