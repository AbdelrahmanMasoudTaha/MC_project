import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app/screens/product_screen.dart';
import 'package:transparent_image/transparent_image.dart';
import '../models/prodect.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product});
  final Product product;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return ProductScreen(product: product);
        }));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 100, vertical: 10),
        width: 150,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(children: [
              FadeInImage(
                width: 200,
                //fit: BoxFit.cover,
                height: 180,
                placeholder: MemoryImage(kTransparentImage),
                image: NetworkImage(
                  product.imageLink,
                ),
              ),
              Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    color: Colors.black45,
                    child: Text(
                      product.name,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.alef(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ))
            ]),
            Text(
              'rate : ${product.rate.toStringAsFixed(1)}',
              style: GoogleFonts.alef(
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            ),
            const SizedBox(
              width: 40,
            ),
            Text(
              'category : ${product.category.name}',
              textAlign: TextAlign.center,
              maxLines: 2,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.alef(
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
