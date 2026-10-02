import 'dart:async';

import 'package:flutter/material.dart';

import '../models/listing_model.dart';
import '../services/firestore_service.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart';

final marketplaceProvider = Provider<MarketplaceViewModel>((ref) {
  return MarketplaceViewModel();
});

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

  Future<String?> uploadImage(File imageFile) async {
    // Apne Cloudinary dashboard ki details yahan dalein
    const cloudName = 'nwvgdxul'; 
    const uploadPreset = 'xale_preset';

    final uri = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');

    try {
      final request = http.MultipartRequest('POST', uri)
        ..fields['upload_preset'] = uploadPreset
        ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Cloudinary se direct https URL milta hai
        return data['secure_url'] as String;
      } else {
        throw "Upload failed with status: ${response.statusCode}";
      }
    } catch (e) {
      throw "Cloudinary Error: $e";
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
