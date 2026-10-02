import 'package:flutter/material.dart';

final List<dynamic> kWishlistItems = [];

class ProductCard extends StatefulWidget {
  final dynamic item;
  final VoidCallback onTap;

  const ProductCard({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final String title = (item is Map ? item['title'] : item?.title ?? 'No Title').toString();
    final String price = (item is Map ? item['price'] : item?.price ?? '0').toString();
    final String description = (item is Map ? item['description'] : item?.description ?? '').toString();
    final String rawImg = (item is Map ? item['imageUrl'] : item?.imageUrl ?? '').toString().trim();
    final bool hasValidImg = rawImg.isNotEmpty && rawImg.startsWith('http');

    final bool isLiked = kWishlistItems.any((e) {
      final eTitle = (e is Map ? e['title'] : e?.title ?? '').toString();
      return eTitle == title;
    });

    return Card(
      elevation: 1.5,
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: widget.onTap,
        child: Container(
          height: 110,
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              // Product Image
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                  width: 90,
                  height: 90,
                  child: hasValidImg
                      ? Image.network(
                          rawImg,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => Container(
                            color: Colors.grey.shade200,
                            child: const Icon(Icons.image_not_supported_outlined, color: Colors.grey),
                          ),
                        )
                      : Container(
                          color: const Color(0xFFEDE7F6),
                          child: const Icon(Icons.shopping_bag_outlined, color: Color(0xFF183661), size: 32),
                        ),
                ),
              ),
              const SizedBox(width: 14),

              // Product Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '₹ $price',
                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: Color(0xFF183661)),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black87),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      description.isEmpty ? 'Campus Item' : description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),

              // Heart / Wishlist Button
              IconButton(
                icon: Icon(
                  isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                  color: isLiked ? Colors.pink : Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    if (isLiked) {
                      kWishlistItems.removeWhere((e) {
                        final eTitle = (e is Map ? e['title'] : e?.title ?? '').toString();
                        return eTitle == title;
                      });
                    } else {
                      kWishlistItems.add(item);
                    }
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}