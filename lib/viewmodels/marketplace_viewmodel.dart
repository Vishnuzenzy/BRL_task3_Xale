import 'dart:async';
import 'package:flutter/material.dart';
import '../models/listing_model.dart';
import '../services/firestore_service.dart';

class MarketplaceViewModel with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  List<ListingModel> _listings = [];
  bool _isLoading = true;
  String? _errorMessage;
  StreamSubscription? _subscription;

  List<ListingModel> get listings => _listings;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  MarketplaceViewModel() {
    fetchListings();
  }

  void fetchListings() {
    _isLoading = true;
    notifyListeners();

    _subscription?.cancel();
    _subscription = _firestoreService.getListings().listen(
      (items) {
        _listings = items;
        _isLoading = false;
        _errorMessage = null;
        notifyListeners();
      },
      onError: (error) {
        _isLoading = false;
        _errorMessage = error.toString();
        notifyListeners();
      },
    );
  }

  Future<String?> createListing({
    required String title,
    required String description,
    required double price,
    required String sellerId,
    required String imageUrl,
  }) async {
    try {
      final newListing = ListingModel(
        id: '',
        title: title,
        description: description,
        price: price,
        sellerId: sellerId,
        imageUrl: imageUrl,
        createdAt: DateTime.now(),
      );
      await _firestoreService.addListing(newListing);
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}