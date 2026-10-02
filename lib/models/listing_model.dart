class ListingModel {
  final String id;
  final String title;
  final String description;
  final double price;
  final String sellerId;
  final String imageUrl;
  final String category;
  final DateTime createdAt;

  ListingModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.sellerId,
    required this.imageUrl,
    this.category = 'Other',
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'sellerId': sellerId,
      'imageUrl': imageUrl,
      'category': category,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory ListingModel.fromMap(Map<String, dynamic> map, String docId) {
    double parsedPrice = 0.0;
    if (map['price'] != null) {
      if (map['price'] is num) {
        parsedPrice = (map['price'] as num).toDouble();
      } else {
        parsedPrice = double.tryParse(map['price'].toString().replaceAll(',', '')) ?? 0.0;
      }
    }

    DateTime parsedDate = DateTime.now();
    if (map['createdAt'] != null) {
      if (map['createdAt'] is String) {
        parsedDate = DateTime.tryParse(map['createdAt']) ?? DateTime.now();
      } else {
        try {
          parsedDate = (map['createdAt'] as dynamic).toDate();
        } catch (_) {}
      }
    }

    return ListingModel(
      id: docId,
      title: (map['title'] ?? '').toString(),
      description: (map['description'] ?? '').toString(),
      price: parsedPrice,
      sellerId: (map['sellerId'] ?? '').toString(),
      imageUrl: (map['imageUrl'] ?? '').toString(),
      category: (map['category'] ?? 'Other').toString(),
      createdAt: parsedDate,
    );
  }
}