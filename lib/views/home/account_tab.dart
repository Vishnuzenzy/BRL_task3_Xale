import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/mock_marketplace_data.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../widgets/product_card.dart';
import 'item_detail_screen.dart';
import 'mock_detail_screen.dart';

class AccountTab extends ConsumerStatefulWidget {
  final VoidCallback onLogout;
  const AccountTab({super.key, required this.onLogout});

  @override
  ConsumerState<AccountTab> createState() => _AccountTabState();
}

class _AccountTabState extends ConsumerState<AccountTab> {
  String _name = '';
  String _gender = 'Male';
  String _collegeYear = '2nd Year';
  bool _notifications = true;
  bool _darkMode = false;

  @override
  void initState() {
    super.initState();
    final user = ref.read(authProvider).user;
    _name = (user?.displayName != null && user!.displayName!.isNotEmpty)
        ? user.displayName!
        : (user?.email?.split('@').first.toUpperCase() ?? 'Campus Student');
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;
    final email = user?.email ?? 'student@akgec.ac.in';
    final photoUrl = user?.photoURL;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
      children: [
        // 1. PROFILE CARD (With View & Edit)
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: const Color(0xFF183661).withValues(alpha: 0.1),
                    backgroundImage: (photoUrl != null && photoUrl.isNotEmpty) ? NetworkImage(photoUrl) : null,
                    child: (photoUrl == null || photoUrl.isEmpty)
                        ? Text(_name.isNotEmpty ? _name[0] : 'U', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF183661)))
                        : null,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF183661))),
                        const SizedBox(height: 2),
                        Text(email, style: const TextStyle(fontSize: 12, color: Colors.blueGrey)),
                        const SizedBox(height: 6),
                        Text("$_gender  •  $_collegeYear", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF183661))),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _showViewProfile(email),
                      child: const Text("View Profile", style: TextStyle(color: Color(0xFF183661))),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF183661)),
                      onPressed: _showEditProfile,
                      child: const Text("Edit Profile", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // 2. WORKING WISHLIST TILE
        Card(
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          child: ListTile(
            leading: const Icon(Icons.favorite_rounded, color: Colors.pink),
            title: Text("My Wishlist (${kWishlistItems.length})", style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text("Tap to view your saved campus items", style: TextStyle(fontSize: 12)),
            trailing: const Icon(Icons.chevron_right),
            onTap: _openWishlistSheet,
          ),
        ),
        const SizedBox(height: 10),

        // 3. BASIC SETTINGS & HELP (Lightweight)
        Container(
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
          child: Column(
            children: [
              SwitchListTile(
                secondary: const Icon(Icons.notifications_none_rounded, color: Color(0xFF183661)),
                title: const Text("Notifications", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                value: _notifications,
                activeThumbColor: const Color(0xFF183661),
                onChanged: (v) => setState(() => _notifications = v),
              ),
              const Divider(height: 1),
              SwitchListTile(
                secondary: const Icon(Icons.dark_mode_outlined, color: Color(0xFF183661)),
                title: const Text("Dark Theme (Preview)", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                value: _darkMode,
                activeThumbColor: const Color(0xFF183661),
                onChanged: (v) => setState(() => _darkMode = v),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.help_outline_rounded, color: Color(0xFF183661)),
                title: const Text("Help & Support", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                subtitle: const Text("support@xalecampus.in • Meet safely on campus", style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // 4. LOGOUT (With Confirmation Dialog)
        ListTile(
          tileColor: Colors.red.shade50,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          leading: const Icon(Icons.logout, color: Colors.red),
          title: const Text("Logout", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          trailing: const Icon(Icons.chevron_right, color: Colors.red),
          onTap: () {
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                title: const Text("Logout?", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF183661))),
                content: const Text("Are you sure you want to log out of your XALE campus account?"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text("Cancel", style: TextStyle(color: Colors.blueGrey)),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {
                      Navigator.pop(ctx);
                      widget.onLogout();
                    },
                    child: const Text("Logout", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  // View Profile Dialog
  void _showViewProfile(String email) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Student Profile"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Name: $_name", style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            Text("Gmail: $email"),
            const SizedBox(height: 6),
            Text("Gender: $_gender"),
            const SizedBox(height: 6),
            Text("Year: $_collegeYear"),
          ],
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Close"))],
      ),
    );
  }

  // Edit Profile Sheet
  void _showEditProfile() {
    final nameCtrl = TextEditingController(text: _name);
    String tempGender = _gender;
    String tempYear = _collegeYear;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(ctx).viewInsets.bottom + 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Edit Profile", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: "Name")),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                initialValue: tempGender,
                decoration: const InputDecoration(labelText: "Gender"),
                items: ['Male', 'Female', 'Other'].map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                onChanged: (v) => setSheetState(() => tempGender = v!),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                initialValue: tempYear,
                decoration: const InputDecoration(labelText: "College Year"),
                items: ['1st Year', '2nd Year', '3rd Year', '4th Year'].map((y) => DropdownMenuItem(value: y, child: Text(y))).toList(),
                onChanged: (v) => setSheetState(() => tempYear = v!),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF183661)),
                  onPressed: () {
                    setState(() {
                      if (nameCtrl.text.trim().isNotEmpty) _name = nameCtrl.text.trim();
                      _gender = tempGender;
                      _collegeYear = tempYear;
                    });
                    Navigator.pop(ctx);
                  },
                  child: const Text("Save", style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Working Wishlist Bottom Sheet
  void _openWishlistSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => SizedBox(
          height: 420,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("My Wishlist (${kWishlistItems.length})", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Expanded(
                  child: kWishlistItems.isEmpty
                      ? const Center(child: Text("No items in wishlist yet. Tap ❤️ on any item to save!"))
                      : ListView.builder(
                          itemCount: kWishlistItems.length,
                          itemBuilder: (_, i) {
                            final item = kWishlistItems[i];
                            return SizedBox(
                              height: 120,
                              child: ProductCard(
                                item: item,
                                onTap: () {
                                  Navigator.pop(ctx);
                                  if (item is MockListing) {
                                    Navigator.push(context, MaterialPageRoute(builder: (_) => MockDetailScreen(item: item)));
                                  } else {
                                    Navigator.push(context, MaterialPageRoute(builder: (_) => ItemDetailScreen(item: item)));
                                  }
                                },
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    ).then((_) => setState(() {})); // Refresh count on close
  }
}