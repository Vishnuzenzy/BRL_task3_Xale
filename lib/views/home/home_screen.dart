import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/marketplace_viewmodel.dart';
import '../../widgets/product_card.dart';
import 'listing_screen.dart';
import 'item_detail_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
    final marketVM = ref.watch(marketplaceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Campus Marketplace"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ref.read(authProvider).signOut();
            },
          ),
        ],
      ),
      body: Builder(
        builder: (context) {
          if (marketVM.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (marketVM.errorMessage != null) {
            return Center(
              child: Text(
                "Error: ${marketVM.errorMessage}",
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (marketVM.listings.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.storefront_outlined,
                    size: 70,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "No items listed yet!",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Tap + to list your first item",
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async => marketVM.fetchListings(),
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.72,
              ),
              itemCount: marketVM.listings.length,
              itemBuilder: (context, index) {
                return ProductCard(
                  item: marketVM.listings[index],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            ItemDetailScreen(item: marketVM.listings[index]),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ListingScreen()),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text("Sell Item"),
      ),
    );
  }
}
