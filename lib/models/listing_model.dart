import 'package:cloud_firestore/cloud_firestore.dart';

class ListingModel {
  final String id;
  final String title;
  final String description;
  final double price;
  final String sellerId;
  final String imageUrl;
  final DateTime createdAt;

  ListingModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.sellerId,
    required this.imageUrl,
    required this.createdAt,
  });

  // Firestore se data read karne ke liye
  factory ListingModel.fromMap(Map<String, dynamic> map, String documentId) {
    return ListingModel(
      id: documentId,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
      sellerId: map['sellerId'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  // Firestore mein data write karne ke liye
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'price': price,
      'sellerId': sellerId,
      'imageUrl': imageUrl,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}