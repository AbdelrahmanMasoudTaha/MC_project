import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mobile_app/models/prodect.dart';
import 'package:http/http.dart' as http;

class AdminProductCard extends StatefulWidget {
  AdminProductCard({super.key, required this.product});
  final Product product;

  @override
  State<AdminProductCard> createState() => _AdminProductCardState();
}

class _AdminProductCardState extends State<AdminProductCard> {
  int? add;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
          color: Colors.black12, borderRadius: BorderRadius.circular(20)),
      margin: const EdgeInsets.all(5),
      child: ListTile(
        title: Text(
          widget.product.name,
          style: GoogleFonts.alef(
            fontWeight: FontWeight.w600,
            fontSize: 25,
            // color: Theme.of(context).colorScheme.primary,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Number in the Stock : ${add == null ? widget.product.numInStock : add! + widget.product.numInStock}',
                  style: GoogleFonts.alef(
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        final TextEditingController quantityController =
                            TextEditingController();

                        return AlertDialog(
                          title: Text(
                            'Modify the stock',
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

                                  addToStock(widget.product.id, quant);
                                  Navigator.of(context).pop();
                                  showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: Text(
                                        'Stock Modified',
                                        style: GoogleFonts.alef(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 18,
                                        ),
                                      ),
                                      content: Text(
                                        'You add "${widget.product.name}" with a quantity of $quantity.',
                                        style: GoogleFonts.alef(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 18,
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(ctx).pop();
                                            setState(() {
                                              add = quant;
                                            });
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
                  icon: const Icon(Icons.edit),
                ),
              ],
            ),
            Text(
              'User Rateing : ${widget.product.rate.toStringAsFixed(1)}',
              style: GoogleFonts.alef(
                fontWeight: FontWeight.w400,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void addToStock(String pid, int numToAdd) async {
    final url = Uri.https('mobile-app-e112c-default-rtdb.firebaseio.com',
        '/product-list/$pid.json');
    try {
      final response = await http.patch(
        url,
        body: json.encode({
          'numInStock': widget.product.numInStock + numToAdd,
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
}
