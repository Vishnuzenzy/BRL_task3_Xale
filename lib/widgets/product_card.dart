import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Local cache per user UID
final Map<String, List<Map<String, dynamic>>> _userWishlists = {};
final Set<String> _loadedUsers = {};

// Dynamic getter: Returns current user's wishlist & auto-loads from Firestore on restart
List<dynamic> get kWishlistItems {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) return [];
  return _userWishlists.putIfAbsent(uid, () => []);
}

// Convert any item (ListingModel, MockListing, or Map) into a clean Map for Firestore
Map<String, dynamic> _itemToMap(dynamic item) {
  if (item is Map<String, dynamic>) return item;
  if (item is Map) return Map<String, dynamic>.from(item);
  return {
    'title': (item?.title ?? '').toString(),
    'price': (item?.price ?? '0').toString(),
    'description': (item?.description ?? '').toString(),
    'imageUrl': (item?.imageUrl ?? '').toString(),
    'category': (item?.category ?? 'Other').toString(),
  };
}

// Fetch saved wishlist from Firestore after Hot Restart / App Launch
Future<void> loadWishlistFromFirestore([VoidCallback? onLoaded]) async {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid == null || _loadedUsers.contains(uid)) return;
  _loadedUsers.add(uid);

  try {
    final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (doc.exists && doc.data() != null && doc.data()!['wishlist'] is List) {
      final List<dynamic> rawList = doc.data()!['wishlist'];
      _userWishlists[uid] = rawList.map((e) => Map<String, dynamic>.from(e as Map)).toList();
      if (onLoaded != null) onLoaded();
    }
  } catch (_) {}
}

// Save updated wishlist to Firestore
Future<void> _syncWishlistToFirestore() async {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) return;
  final list = _userWishlists[uid] ?? [];
  try {
    await FirebaseFirestore.instance.collection('users').doc(uid).set(
      {'wishlist': list},
      SetOptions(merge: true),
    );
  } catch (_) {}
}

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
  void initState() {
    super.initState();
    // Auto-load saved wishlist from Firestore on first render after Hot Restart
    loadWishlistFromFirestore(() {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final String title = (item is Map ? item['title'] : item?.title ?? 'No Title').toString();
    final String price = (item is Map ? item['price'] : item?.price ?? '0').toString();
    final String description = (item is Map ? item['description'] : item?.description ?? '').toString();
    final String rawImg = (item is Map ? item['imageUrl'] : item?.imageUrl ?? '').toString().trim();
    final bool hasValidImg = rawImg.isNotEmpty && rawImg.startsWith('http');

    final currentWishlist = kWishlistItems;
    final bool isLiked = currentWishlist.any((e) {
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
                  final uid = FirebaseAuth.instance.currentUser?.uid;
                  if (uid == null) return;
                  final userList = _userWishlists.putIfAbsent(uid, () => []);

                  setState(() {
                    if (isLiked) {
                      userList.removeWhere((e) => (e['title'] ?? '').toString() == title);
                    } else {
                      userList.add(_itemToMap(item));
                    }
                  });

                  // Sync permanently to Firestore
                  _syncWishlistToFirestore();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}