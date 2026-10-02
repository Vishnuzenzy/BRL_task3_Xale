import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/listing_model.dart';
import '../../models/mock_marketplace_data.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/marketplace_viewmodel.dart';
import '../../widgets/product_card.dart';
import 'listing_screen.dart';
import 'item_detail_screen.dart';
import 'mock_detail_screen.dart';
import 'account_tab.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _tabIndex = 0;
  String _searchQuery = '';
  String _selectedCat = 'All';

  @override
  Widget build(BuildContext context) {
    final marketVM = ref.watch(marketplaceProvider);
    final authVM = ref.watch(authProvider);

    // 1. Live Firestore Listings (Newest first)
    final List<dynamic> realListings = [...marketVM.listings];
    realListings.sort((a, b) {
      try {
        return b.createdAt.compareTo(a.createdAt);
      } catch (_) {
        return 0;
      }
    });

    // 2. Real items on top, followed by mock items
    final List<dynamic> allCombinedListings = [
      ...realListings,
      ...kCategoryMockItems,
    ];

    // Filter by Search Query and Selected Category
    final filteredListings = allCombinedListings.where((item) {
      if (item == null) return false;
      try {
        final title = (item.title ?? '').toString().toLowerCase();
        final desc = (item.description ?? '').toString().toLowerCase();
        final cat = (item.category ?? '').toString().toLowerCase();

        final matchSearch =
            title.contains(_searchQuery.toLowerCase()) ||
            desc.contains(_searchQuery.toLowerCase());
        final matchCat =
            _selectedCat == 'All' ||
            cat == _selectedCat.toLowerCase() ||
            title.contains(_selectedCat.toLowerCase());

        return matchSearch && matchCat;
      } catch (_) {
        return false;
      }
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Row(
          children: const [
            Icon(Icons.school_rounded, color: Color(0xFF183661), size: 26),
            SizedBox(width: 6),
            Text(
              "XALE",
              style: TextStyle(
                color: Color(0xFF183661),
                fontWeight: FontWeight.w900,
                fontSize: 22,
              ),
            ),
            Spacer(),
            Icon(Icons.location_on_outlined, size: 16, color: Colors.black87),
            SizedBox(width: 4),
            Text(
              "Ghaziabad",
              style: TextStyle(
                color: Colors.black87,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      body: _tabIndex == 0
          ? _buildHomeFeed(filteredListings)
          : _tabIndex == 1
          ? _buildChatTab()
          : _tabIndex == 2
          ? _buildMyAdsTab(realListings, authVM.user?.uid)
          : AccountTab(
              onLogout: () {
                setState(() => _tabIndex = 0);
                ref.read(authProvider).signOut();
              },
            ),
      floatingActionButton: _tabIndex == 0 || _tabIndex == 2
          ? FloatingActionButton.extended(
              backgroundColor: const Color(0xFF183661),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ListingScreen()),
              ),
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text(
                "SELL",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        height: 65,
        backgroundColor: Colors.white,
        selectedIndex: _tabIndex,
        onDestinationSelected: (i) => setState(() => _tabIndex = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline_rounded),
            selectedIcon: Icon(Icons.chat_bubble_rounded),
            label: 'Chats',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long),
            label: 'My Ads',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Account',
          ),
        ],
      ),
    );
  }

  // TAB 0: HOME FEED
  Widget _buildHomeFeed(List<dynamic> items) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 90),
      children: [
        // Search Bar
        Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 14),
          child: TextField(
            onChanged: (val) => setState(() => _searchQuery = val),
            decoration: InputDecoration(
              hintText: 'Search "Books, Earbuds, Cycles..."',
              prefixIcon: const Icon(Icons.search, color: Color(0xFF183661)),
              filled: true,
              fillColor: const Color(0xFFF2F4F7),
              contentPadding: EdgeInsets.zero,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),

        // Categories
        Container(
          margin: const EdgeInsets.only(top: 8),
          color: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Browse Categories",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (_selectedCat != 'All')
                      GestureDetector(
                        onTap: () => setState(() => _selectedCat = 'All'),
                        child: const Text(
                          "Clear Filter",
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 98,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: kCategories.length,
                  itemBuilder: (_, i) {
                    final cat = kCategories[i];
                    final isSel = _selectedCat == cat['name'];
                    return GestureDetector(
                      onTap: () => setState(() => _selectedCat = cat['name']!),
                      child: Container(
                        width: 78,
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        child: Column(
                          children: [
                            Container(
                              height: 66,
                              width: 66,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isSel
                                      ? const Color(0xFF183661)
                                      : Colors.grey.shade200,
                                  width: isSel ? 2.5 : 1,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(14),
                                child: Image.network(
                                  cat['img']!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              cat['name']!,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: isSel
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                                color: isSel
                                    ? const Color(0xFF183661)
                                    : Colors.black87,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),

        // Spotlight Deals
        Container(
          margin: const EdgeInsets.only(top: 10),
          color: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Campus Spotlight Deals 🔥",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Swipe →",
                      style: TextStyle(fontSize: 12, color: Colors.blueGrey),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 195,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: kFeaturedSpotlight.length,
                  itemBuilder: (_, i) {
                    final spot = kFeaturedSpotlight[i];
                    return GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MockDetailScreen(item: spot),
                        ),
                      ),
                      child: Container(
                        width: 160,
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(13),
                              ),
                              child: Image.network(
                                spot.imageUrl,
                                height: 115,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '₹ ${spot.price}',
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF183661),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    spot.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),

        // Listings Header
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _selectedCat == 'All'
                    ? "Fresh Campus Listings"
                    : "Showing '$_selectedCat'",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "${items.length} items",
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),

        // Listings Feed
        if (items.isEmpty)
          const Padding(
            padding: EdgeInsets.all(32),
            child: Center(
              child: Text(
                "No items found. Tap '+ SELL' to add one!",
                style: TextStyle(color: Colors.blueGrey),
              ),
            ),
          )
        else
          ...items.map(
            (listing) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: SizedBox(
                height: 125,
                child: ProductCard(
                  item: listing,
                  onTap: () {
                    if (listing is MockListing) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MockDetailScreen(item: listing),
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ItemDetailScreen(item: listing),
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ),
      ],
    );
  }

  // TAB 1: CHATS TAB (Coming Soon)
  Widget _buildChatTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "Campus Chats 💬",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF183661),
                ),
              ),
              SizedBox(height: 4),
              Text(
                "Direct buyer & seller conversations inside campus",
                style: TextStyle(fontSize: 13, color: Colors.blueGrey),
              ),
            ],
          ),
        ),
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: const Color(0xFF183661).withOpacity(0.08),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.forum_rounded,
                      size: 56,
                      color: Color(0xFF183661),
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    "Feature Coming Soon!",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF183661),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Real-time instant messaging with verified students and hostelers is under development. Stay tuned!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.blueGrey,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // TAB 2: MY ADS TAB (With Edit & Delete Options)
  Widget _buildMyAdsTab(List<dynamic> realListings, String? uid) {
    final myAds = realListings.where((item) => item.sellerId == uid).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 14),
          child: Text(
            "My Posted Ads (${myAds.length})",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF183661),
            ),
          ),
        ),
        Expanded(
          child: myAds.isEmpty
              ? const Center(
                  child: Text(
                    "You haven't posted any ads yet. Tap + SELL to post!",
                    style: TextStyle(color: Colors.blueGrey),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 90),
                  itemCount: myAds.length,
                  itemBuilder: (_, i) {
                    final ListingModel ad = myAds[i];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 1.5,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 120,
                            child: ProductCard(
                              item: ad,
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ItemDetailScreen(item: ad),
                                ),
                              ),
                            ),
                          ),
                          const Divider(height: 1),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton.icon(
                                  onPressed: () => _showEditAdDialog(ad),
                                  icon: const Icon(
                                    Icons.edit_outlined,
                                    size: 18,
                                    color: Color(0xFF183661),
                                  ),
                                  label: const Text(
                                    "Edit",
                                    style: TextStyle(
                                      color: Color(0xFF183661),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                TextButton.icon(
                                  onPressed: () => _confirmDeleteAd(ad.id),
                                  icon: const Icon(
                                    Icons.delete_outline_rounded,
                                    size: 18,
                                    color: Colors.red,
                                  ),
                                  label: const Text(
                                    "Delete",
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  // Delete Confirmation Dialog
  void _confirmDeleteAd(String docId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete Ad?"),
        content: const Text(
          "Are you sure you want to remove this listing from campus marketplace?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(ctx);
              final err = await ref
                  .read(marketplaceProvider)
                  .deleteListing(docId);

              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      err == null ? "Ad deleted successfully" : "Error: $err",
                    ),
                  ),
                );
              }
            },
            child: const Text("Delete", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // Edit Bottom Sheet Dialog
  void _showEditAdDialog(ListingModel ad) {
    final titleCtrl = TextEditingController(text: ad.title);
    final priceCtrl = TextEditingController(text: ad.price.toStringAsFixed(0));
    final descCtrl = TextEditingController(text: ad.description);
    final categories = [
      'Watches',
      'Mobiles',
      'Bikes',
      'Laptops',
      'Books',
      'Audio',
      'Furniture',
      'Other',
    ];
    String selectedCat = categories.contains(ad.category)
        ? ad.category
        : 'Other';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Edit Campus Ad",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF183661),
                      ),
                    ),
                    const SizedBox(height: 14),
                    DropdownButtonFormField<String>(
                      value: selectedCat,
                      decoration: InputDecoration(
                        labelText: "Category",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      items: categories
                          .map(
                            (c) => DropdownMenuItem(value: c, child: Text(c)),
                          )
                          .toList(),
                      onChanged: (val) =>
                          setSheetState(() => selectedCat = val!),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: titleCtrl,
                      decoration: InputDecoration(
                        labelText: "Title",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: priceCtrl,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Price (₹)",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: descCtrl,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: "Description",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF183661),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () async {
                          final newTitle = titleCtrl.text.trim();
                          final newDesc = descCtrl.text.trim();
                          final newPrice =
                              double.tryParse(priceCtrl.text.trim()) ??
                              ad.price;

                          Navigator.pop(ctx);

                          // Named arguments pass kar rahe hain jaisa ViewModel expect kar raha hai
                          final err = await ref
                              .read(marketplaceProvider)
                              .updateListing(
                                id: ad.id,
                                title: newTitle,
                                description: newDesc,
                                price: newPrice,
                                category: selectedCat,
                              );

                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  err == null ? "Ad updated!" : "Error: $err",
                                ),
                              ),
                            );
                          }
                        },
                        child: const Text(
                          "Save Changes",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
