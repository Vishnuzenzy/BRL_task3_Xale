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
  int _tabIndex = 0;
  String _searchQuery = '';
  String _selectedCat = 'All';

  final List<Map<String, String>> _categories = [
    {'name': 'All', 'img': 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=300&q=80'},
    {'name': 'Mobiles', 'img': 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?auto=format&fit=crop&w=300&q=80'},
    {'name': 'Bikes', 'img': 'https://images.unsplash.com/photo-1558981403-c5f9899a28bc?auto=format&fit=crop&w=300&q=80'},
    {'name': 'Laptops', 'img': 'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?auto=format&fit=crop&w=300&q=80'},
    {'name': 'Books', 'img': 'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?auto=format&fit=crop&w=300&q=80'},
    {'name': 'Audio', 'img': 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=300&q=80'},
    {'name': 'Furniture', 'img': 'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?auto=format&fit=crop&w=300&q=80'},
  ];

  final List<Map<String, String>> _featuredSpotlight = [
    {'title': 'Boat Airdopes Pro', 'price': '₹ 1,000', 'img': 'https://images.unsplash.com/photo-1590658268037-6bf12165a8df?auto=format&fit=crop&w=500&q=80'},
    {'title': 'Casio FX-991EX Calc', 'price': '₹ 650', 'img': 'https://images.unsplash.com/photo-1587145820266-a5951ee6f620?auto=format&fit=crop&w=500&q=80'},
    {'title': 'Hero Sprint Cycle', 'price': '₹ 3,200', 'img': 'https://images.unsplash.com/photo-1485965120184-e220f721d03e?auto=format&fit=crop&w=500&q=80'},
    {'title': 'Engineering Books Set', 'price': '₹ 450', 'img': 'https://images.unsplash.com/photo-1497633762265-9d179a990aa6?auto=format&fit=crop&w=500&q=80'},
  ];

  @override
  Widget build(BuildContext context) {
    final marketVM = ref.watch(marketplaceProvider);
    final authVM = ref.watch(authProvider);

    List<dynamic> rawListings = [];
    try {
      if (marketVM.listings != null) {
        rawListings = List<dynamic>.from(marketVM.listings);
      }
    } catch (_) {
      rawListings = [];
    }

    final filteredListings = rawListings.where((item) {
      if (item == null) return false;
      try {
        final title = (item.title ?? '').toString().toLowerCase();
        final desc = (item.description ?? '').toString().toLowerCase();
        final matchSearch = title.contains(_searchQuery.toLowerCase());
        final matchCat = _selectedCat == 'All' ||
            title.contains(_selectedCat.toLowerCase()) ||
            desc.contains(_selectedCat.toLowerCase());
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
              style: TextStyle(color: Color(0xFF183661), fontWeight: FontWeight.w900, fontSize: 22),
            ),
            Spacer(),
            Icon(Icons.location_on_outlined, size: 16, color: Colors.black87),
            SizedBox(width: 4),
            Text(
              "Ghaziabad",
              style: TextStyle(color: Colors.black87, fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
      body: _tabIndex == 0
          ? _buildHomeTab(filteredListings)
          : _tabIndex == 1
              ? _buildMyAdsTab(rawListings, authVM.user?.uid)
              : _buildAccountTab(authVM),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF183661),
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ListingScreen())),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("SELL", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      bottomNavigationBar: NavigationBar(
        height: 65,
        backgroundColor: Colors.white,
        selectedIndex: _tabIndex,
        onDestinationSelected: (i) => setState(() => _tabIndex = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.receipt_long_outlined), selectedIcon: Icon(Icons.receipt_long), label: 'My Ads'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Account'),
        ],
      ),
    );
  }

  Widget _buildHomeTab(List<dynamic> items) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 90),
      children: [
        // 1. Search Bar
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
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            ),
          ),
        ),

        // 2. Horizontally Slidable Categories
        Container(
          margin: const EdgeInsets.only(top: 8),
          color: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text("Browse Categories", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 98,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: _categories.length,
                  itemBuilder: (_, i) {
                    final cat = _categories[i];
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
                                  color: isSel ? const Color(0xFF183661) : Colors.grey.shade200,
                                  width: isSel ? 2.5 : 1,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(14),
                                child: Image.network(
                                  cat['img']!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, _, _) => const Icon(Icons.category, color: Color(0xFF183661)),
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              cat['name']!,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: isSel ? FontWeight.bold : FontWeight.w500,
                                color: isSel ? const Color(0xFF183661) : Colors.black87,
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

        // 3. Horizontally Slidable Recommendations
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
                    Text("Recommended For You", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Text("Swipe →", style: TextStyle(fontSize: 12, color: Colors.blueGrey)),
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
                  itemCount: _featuredSpotlight.length,
                  itemBuilder: (_, i) {
                    final spot = _featuredSpotlight[i];
                    return Container(
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
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(13)),
                            child: Image.network(
                              spot['img']!,
                              height: 115,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (_, _, _) => Container(
                                height: 115,
                                color: Colors.grey.shade200,
                                child: const Icon(Icons.image, size: 40, color: Colors.grey),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(spot['price']!, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF183661))),
                                const SizedBox(height: 2),
                                Text(spot['title']!, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
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
          ),
        ),

        // 4. Fresh Campus Listings Header
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 14, 16, 6),
          child: Text("Fresh Campus Listings", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),

        // 5. Listings (Protected with explicit height constraint to prevent RenderFlex crash)
        if (items.isEmpty)
          const Padding(
            padding: EdgeInsets.all(24),
            child: Center(
              child: Text("Tap '+ SELL' to post your first item on campus!", style: TextStyle(color: Colors.blueGrey)),
            ),
          )
        else
          ...items.map((listingItem) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: SizedBox(
                height: 130, // Incoming height constraint provided
                child: ProductCard(
                  item: listingItem,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ItemDetailScreen(item: listingItem)),
                  ),
                ),
              ),
            );
          }),
      ],
    );
  }

  Widget _buildMyAdsTab(List<dynamic> allListings, String? uid) {
    final myAds = allListings.where((item) => item != null && item.sellerId == uid).toList();
    if (myAds.isEmpty) return const Center(child: Text("You haven't posted any ads yet."));
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: myAds.length,
      itemBuilder: (_, i) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: SizedBox(
          height: 130,
          child: ProductCard(
            item: myAds[i],
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ItemDetailScreen(item: myAds[i]))),
          ),
        ),
      ),
    );
  }

  Widget _buildAccountTab(dynamic authVM) {
    final email = authVM.user?.email ?? "Campus Student";
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ListTile(
          tileColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          leading: const CircleAvatar(backgroundColor: Color(0xFF183661), child: Icon(Icons.person, color: Colors.white)),
          title: Text(email.split('@').first.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(email),
        ),
        const SizedBox(height: 12),
        Card(
          child: ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text("Logout", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            onTap: () {
              setState(() => _tabIndex = 0);
              ref.read(authProvider).signOut();
            },
          ),
        ),
      ],
    );
  }
}