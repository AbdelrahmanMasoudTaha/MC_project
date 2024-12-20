import 'dart:developer';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app/models/prodect.dart';
import 'package:mobile_app/widgets/admin_product_card.dart';

class AllProductsScreen extends StatefulWidget {
  const AllProductsScreen({super.key, required this.allProducts});
  final List<Product> allProducts;

  @override
  State<AllProductsScreen> createState() => _AllProductsScreenState();
}

class _AllProductsScreenState extends State<AllProductsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Text(
            'All Products',
            style: GoogleFonts.alef(
              fontWeight: FontWeight.w600,
              fontSize: 30,
              // color: Theme.of(context).colorScheme.primary,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (ctx, index) {
                Product product = widget.allProducts[index];
                return GestureDetector(
                  onLongPress: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Delete Product'),
                        content: Text(
                            'Are you sure you want to delete ${product.name}?'),
                        actions: [
                          TextButton(
                            onPressed: () =>
                                Navigator.pop(context), // Dismiss dialog
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context); // Dismiss dialog
                              _deleteProduct(product.id);
                              setState(() {}); // Call delete function
                            },
                            child: Text('Delete'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: AdminProductCard(product: product),
                );
              },
              itemCount: widget.allProducts.length,
            ),
          )
        ],
      ),
    );
  }

  Future<void> _deleteProduct(String productId) async {
    final url = Uri.https('mobile-app-e112c-default-rtdb.firebaseio.com',
        '/product-list/$productId.json');
    try {
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        log('Product deleted successfully');
      } else {
        log('Failed to delete product: ${response.statusCode}');
        log('Error: ${response.body}');
      }
    } catch (error) {
      log('An error occurred: $error');
    }
  }
}
