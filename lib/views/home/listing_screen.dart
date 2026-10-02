import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/marketplace_viewmodel.dart';

class ListingScreen extends ConsumerStatefulWidget {
  const ListingScreen({super.key});

  @override
  ConsumerState<ListingScreen> createState() => _ListingScreenState();
}

class _ListingScreenState extends ConsumerState<ListingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _descController = TextEditingController();
  
  File? _selectedImage;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _descController.dispose();
    super.dispose();
  }

  // Gallery se photo select karne ka method
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70, // Size optimize karne ke liye
    );

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _submitListing() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select an item photo"), backgroundColor: Colors.orange),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final authVM = ref.read(authProvider);
      final marketVM = ref.read(marketplaceProvider);
      
      // 1. Image upload to Firebase Storage
      final imageUrl = await marketVM.uploadImage(_selectedImage!);
      if (imageUrl == null) {
        throw "Failed to upload image. Please check your connection.";
      }

      final parsedPrice = double.tryParse(_priceController.text.trim()) ?? 0.0;

      // 2. Listing document creation in Firestore
      final error = await marketVM.createListing(
        title: _titleController.text.trim(),
        description: _descController.text.trim(),
        price: parsedPrice,
        sellerId: authVM.user?.uid ?? 'unknown',
        imageUrl: imageUrl,
      );

      if (error != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error), backgroundColor: Colors.red),
        );
      } else if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Item listed successfully!")),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sell an Item")),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Image Picker Tap Container
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 180,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade400),
                ),
                child: _selectedImage != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(_selectedImage!, fit: BoxFit.cover, width: double.infinity),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.add_a_photo_outlined, size: 48, color: Colors.grey),
                          SizedBox(height: 8),
                          Text("Tap to select item photo", style: TextStyle(color: Colors.black54)),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: "Title", border: OutlineInputBorder()),
              validator: (val) => val!.isEmpty ? "Enter a title" : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _priceController,
              decoration: const InputDecoration(labelText: "Price (₹)", prefixText: "₹ ", border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
              validator: (val) => val!.isEmpty ? "Enter price" : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descController,
              decoration: const InputDecoration(labelText: "Description", border: OutlineInputBorder()),
              maxLines: 3,
              validator: (val) => val!.isEmpty ? "Enter description" : null,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isSubmitting ? null : _submitListing,
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
              child: _isSubmitting 
                  ? const CircularProgressIndicator(color: Colors.white) 
                  : const Text("List Item", style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}