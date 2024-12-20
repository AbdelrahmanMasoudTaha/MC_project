import 'dart:convert';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app/models/prodect.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_app/models/transaction.dart';

import '../providers/cart_provider.dart';

class ProductScreen extends ConsumerStatefulWidget {
  const ProductScreen({super.key, required this.product});
  final Product product;

  @override
  ConsumerState<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends ConsumerState<ProductScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.product.name,
          style: GoogleFonts.alef(
            fontWeight: FontWeight.w600,
            fontSize: 30,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Container(
              width: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                // image: NetworkImage(widget.product.imageLink)
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  widget.product.imageLink,
                  fit: BoxFit.fill,
                  height: 250,
                  width: double.infinity,
                ),
              ),
            ),
            const SizedBox(
              height: 14,
            ),
            Row(
              children: [
                Text(
                  'Price :',
                  style: GoogleFonts.alef(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(
                  width: 7,
                ),
                Text(
                  '${widget.product.price} \$',
                  style: GoogleFonts.alef(
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  'Category :',
                  style: GoogleFonts.alef(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(
                  width: 7,
                ),
                Text(
                  widget.product.category.name,
                  style: GoogleFonts.alef(
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 14,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      'Rate :',
                      style: GoogleFonts.alef(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(
                      width: 7,
                    ),
                    Text(
                      widget.product.rate.toStringAsFixed(1),
                      style: GoogleFonts.alef(
                        fontWeight: FontWeight.w700,
                        fontSize: 24,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.8),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () async {
                      final selectedRate = await showDialog<int>(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(
                              'Rate This Product',
                              style: GoogleFonts.alef(
                                fontWeight: FontWeight.w400,
                                fontSize: 18,
                              ),
                            ),
                            content: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(5, (index) {
                                  final rate = index + 1;
                                  return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.pop(context, rate);
                                        },
                                        child: CircleAvatar(
                                          radius: 18,
                                          child: Text(
                                            '$rate',
                                            style: GoogleFonts.alef(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                      ));
                                }),
                              ),
                            ),
                          );
                        },
                      );

                      if (selectedRate != null) {
                        setState(() {
                          widget.product.rateTheProduct(selectedRate);
                        });
                      }
                    },
                    child: Text(
                      'Rate This Product',
                      style: GoogleFonts.alef(
                        fontWeight: FontWeight.w400,
                        fontSize: 18,
                      ),
                    ))
              ],
            ),
            const SizedBox(
              height: 14,
            ),
            Text(
              'Descreption',
              style: GoogleFonts.alef(
                fontWeight: FontWeight.w700,
                fontSize: 24,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(
              width: 7,
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                widget.product.descreption,
                style: GoogleFonts.alef(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        final TextEditingController quantityController =
                            TextEditingController();

                        return AlertDialog(
                          title: Text(
                            'Buy Now',
                            style: GoogleFonts.alef(
                              fontWeight: FontWeight.w400,
                              fontSize: 18,
                            ),
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Enter quantity',
                                style: GoogleFonts.alef(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextField(
                                controller: quantityController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'Quantity',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Close the dialog
                              },
                              child: Text(
                                'Cancel',
                                style: GoogleFonts.alef(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () async {
                                final quantity = quantityController.text;
                                if (quantity.isNotEmpty) {
                                  int quant = int.tryParse(quantity) ?? 0;
                                  // Close the input dialog and show a confirmation dialog
                                  if (widget.product.numInStock < quant) {
                                    Navigator.of(context).pop();
                                    showDialog(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        title: Text(
                                          'NO Enough Products',
                                          style: GoogleFonts.alef(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 18,
                                          ),
                                        ),
                                        content: Text(
                                          'We hove not a $quant of the product"${widget.product.name}" .',
                                          style: GoogleFonts.alef(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 18,
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(ctx).pop();
                                            },
                                            child: Text(
                                              'OK',
                                              style: GoogleFonts.alef(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 18,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  } else {
                                    userBuying(widget.product.id, quant);
                                    userTranscation(
                                        DateTime.now(),
                                        FirebaseAuth
                                            .instance.currentUser!.email!,
                                        widget.product.name,
                                        quant);
                                    Navigator.of(context).pop();
                                    showDialog(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        title: Text(
                                          'Purchase Details',
                                          style: GoogleFonts.alef(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 18,
                                          ),
                                        ),
                                        content: Text(
                                          'You bought "${widget.product.name}" with a quantity of $quantity.',
                                          style: GoogleFonts.alef(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 18,
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(ctx).pop();
                                            },
                                            child: Text(
                                              'OK',
                                              style: GoogleFonts.alef(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 18,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                }
                              },
                              child: Text(
                                'Confirm',
                                style: GoogleFonts.alef(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).colorScheme.primary.withOpacity(0.8),
                    foregroundColor: Colors.white,
                  ),
                  child: Text(
                    'Buy Now',
                    style: GoogleFonts.alef(
                      fontWeight: FontWeight.w400,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 40,
                ),
                ElevatedButton(
                  onPressed: () {
                    ref.read(cartProvider.notifier).addProduct(widget.product);
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text(
                          'Product Added to Cart',
                          style: GoogleFonts.alef(
                            fontWeight: FontWeight.w400,
                            fontSize: 18,
                          ),
                        ),
                        content: Text(
                          'You Add "${widget.product.name}" To Cart, Go to Cart to Modify Quantity',
                          style: GoogleFonts.alef(
                            fontWeight: FontWeight.w400,
                            fontSize: 18,
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(ctx).pop();
                            },
                            child: Text(
                              'OK',
                              style: GoogleFonts.alef(
                                fontWeight: FontWeight.w400,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).colorScheme.primary.withOpacity(0.8),
                    foregroundColor: Colors.white,
                  ),
                  child: Text(
                    'Add to Cart',
                    style: GoogleFonts.alef(
                      fontWeight: FontWeight.w400,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void userBuying(String pid, int numToBuy) async {
    final url = Uri.https('mobile-app-e112c-default-rtdb.firebaseio.com',
        '/product-list/$pid.json');

    try {
      final response = await http.patch(
        url,
        body: json.encode({
          'numInStock': widget.product.numInStock - numToBuy,
          'soldTimes': widget.product.soldTimes + numToBuy
        }),
      );

      if (response.statusCode == 200) {
        log("Product updated successfully!");
      } else {
        log("Failed to update product: ${response.statusCode}");
      }
    } catch (error) {
      log("Error updating product: $error");
    }
  }

  void userTranscation(
    DateTime date,
    String userEmail,
    String productName,
    int quantity,
  ) {
    final url = Uri.https('mobile-app-e112c-default-rtdb.firebaseio.com',
        'transaction-list.json');
    http
        .post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'productName': productName,
        'userEmail': userEmail,
        'quantity': quantity,
        'date': date.toIso8601String(),
      }),
    )
        .then((res) {
      if (res.statusCode == 200) {
        log('transaction done');
      }
    });
  }
}
