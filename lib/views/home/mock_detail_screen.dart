import 'package:flutter/material.dart';
import '../../models/mock_marketplace_data.dart';

class MockDetailScreen extends StatelessWidget {
  final MockListing item;
  const MockDetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF183661),
        elevation: 0.5,
        title: Text(item.category, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              item.imageUrl,
              height: 280,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(height: 280, color: Colors.grey.shade200, child: const Icon(Icons.image, size: 60)),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: const Color(0xFFE8EEF5), borderRadius: BorderRadius.circular(8)),
                    child: Text(item.category.toUpperCase(), style: const TextStyle(color: Color(0xFF183661), fontWeight: FontWeight.bold, fontSize: 11)),
                  ),
                  const SizedBox(height: 10),
                  Text('₹ ${item.price}', style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Color(0xFF183661))),
                  const SizedBox(height: 6),
                  Text(item.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
                  const Divider(height: 32),
                  const Text("Description", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(item.description, style: const TextStyle(fontSize: 15, color: Colors.black87, height: 1.5)),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(color: const Color(0xFFF6F7FB), borderRadius: BorderRadius.circular(12)),
                    child: Row(
                      children: [
                        const CircleAvatar(backgroundColor: Color(0xFF183661), child: Icon(Icons.verified_user, color: Colors.white, size: 20)),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.sellerName, style: const TextStyle(fontWeight: FontWeight.bold)),
                            const Text("AKGEC Campus • Ghaziabad", style: TextStyle(fontSize: 12, color: Colors.blueGrey)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            height: 52,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF183661),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Interest sent to ${item.sellerName} for ${item.title}!")),
                );
              },
              icon: const Icon(Icons.chat_bubble_outline_rounded),
              label: const Text("Contact Seller / Make Offer", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
        ),
      ),
    );
  }
}