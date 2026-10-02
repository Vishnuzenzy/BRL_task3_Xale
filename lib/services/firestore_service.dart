import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/listing_model.dart';

class FirestoreService {
  final CollectionReference _listingsRef =
      FirebaseFirestore.instance.collection('listings');

  // Real-time stream of all listings (Safe & Crash-Proof)
  Stream<List<ListingModel>> getListings() {
    return _listingsRef.snapshots().map((snapshot) {
      final List<ListingModel> items = [];

      for (final doc in snapshot.docs) {
        try {
          final data = doc.data() as Map<String, dynamic>;
          items.add(ListingModel.fromMap(data, doc.id));
        } catch (e) {
          // Agar koi 1 purana document corrupt bhi ho, toh baaki ads rukenge nahi
          continue;
        }
      }

      // Newest items sabse upar sort honge
      items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return items;
    });
  }

  // Create new listing
  Future<void> addListing(ListingModel listing) async {
    final docRef = _listingsRef.doc();
    final data = listing.toMap();
    data['id'] = docRef.id; // Empty ID ki jagah real Firestore document ID save hogi
    await docRef.set(data);
  }
}