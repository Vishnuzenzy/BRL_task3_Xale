import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  final _imageUrlController = TextEditingController();
  
  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _descController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _submitListing() async {
  if (!_formKey.currentState!.validate()) return;
  setState(() => _isSubmitting = true);

  try {
    final authVM = ref.read(authProvider);
    final marketVM = ref.read(marketplaceProvider);
    
    // Invalid text par crash hone se bachane ke liye double.tryParse
    final parsedPrice = double.tryParse(_priceController.text.trim()) ?? 0.0;

    final error = await marketVM.createListing(
      title: _titleController.text.trim(),
      description: _descController.text.trim(),
      price: parsedPrice,
      sellerId: authVM.user?.uid ?? 'unknown',
      imageUrl: _imageUrlController.text.trim(),
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
        SnackBar(content: Text("Submission Error: $e"), backgroundColor: Colors.red),
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
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: "Title"),
              validator: (val) => val!.isEmpty ? "Enter a title" : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _priceController,
              decoration: const InputDecoration(labelText: "Price (₹)", prefixText: "₹ "),
              keyboardType: TextInputType.number,
              validator: (val) => val!.isEmpty ? "Enter price" : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descController,
              decoration: const InputDecoration(labelText: "Description"),
              maxLines: 3,
              validator: (val) => val!.isEmpty ? "Enter description" : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _imageUrlController,
              decoration: const InputDecoration(labelText: "Image URL"),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _isSubmitting ? null : _submitListing,
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
              child: _isSubmitting 
                  ? const CircularProgressIndicator() 
                  : const Text("List Item"),
                  
            ),
          ],
        ),
      ),
    );
  }
}