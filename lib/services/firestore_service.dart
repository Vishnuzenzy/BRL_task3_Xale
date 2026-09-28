import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/listing_model.dart';

class FirestoreService {
  final CollectionReference _listingsRef =
      FirebaseFirestore.instance.collection('listings');

  // Real-time stream of all listings (latest first)
  Stream<List<ListingModel>> getListings() {
    return _listingsRef
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return ListingModel.fromMap(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }).toList();
    });
  }

  // Create new listing
  Future<void> addListing(ListingModel listing) async {
    await _listingsRef.add(listing.toMap());
  }
}