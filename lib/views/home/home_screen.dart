import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/marketplace_viewmodel.dart';
import '../../widgets/product_card.dart';
import 'listing_screen.dart';
import 'item_detail_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final marketVM = ref.watch(marketplaceProvider);

    // Real-time search filter
    final filteredListings = marketVM.listings.where((item) => 
      item.title.toLowerCase().contains(_searchQuery.toLowerCase())
    ).toList();

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
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search campus items...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: (val) => setState(() => _searchQuery = val),
            ),
          ),
          Expanded(
            child: Builder(
              builder: (context) {
                if (marketVM.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (marketVM.errorMessage != null) {
                  return Center(
                    child: Text("Error: ${marketVM.errorMessage}"),
                  );
                }

                if (filteredListings.isEmpty) {
                  return const Center(child: Text("No items found"));
                }

                return ListView.builder(
                  itemCount: filteredListings.length,
                  itemBuilder: (context, index) {
                    final listingItem = filteredListings[index];
                    return ProductCard(
                      item: listingItem, 
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ItemDetailScreen(item: listingItem)
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ListingScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}