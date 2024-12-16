import 'dart:convert';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app/screens/admin_screens/add_product_screen.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_app/widgets/admin_product_card.dart';

import '../../models/prodect.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  List<Product> allProducts = [];
  List<Product> Top3Products = [];
  int? selectedCategory;
  bool _isLoaded = true;
  String? _erorr;
  final url = Uri.https(
      'mobile-app-e112c-default-rtdb.firebaseio.com', 'product-list.json');
  void _getData() async {
    try {
      final http.Response res = await http.get(url);
      if (res.statusCode >= 400) {
        setState(() {
          _erorr = 'Faild to fetch data, Please try again later';
        });
        return;
      }
      if (res.body == 'null') {
        setState(() {
          _isLoaded = false;
        });
        return;
      }
      final Map<String, dynamic> loadedData = json.decode(res.body);
      final List<Product> loadedItems = [];
      for (var item in loadedData.entries) {
        final Category category = Category.values.firstWhere(
          (e) => e.name == item.value["category"],
          orElse: () => Category.books,
        );
        loadedItems.add(Product(
            soldTimes: item.value['soldTimes'],
            name: item.value['name'],
            id: item.key,
            descreption: item.value['descreption'],
            price: item.value['price'],
            imageLink: item.value['imageLink'],
            numInStock: item.value['numInStock'],
            category: category,
            rate: item.value['rate']));
        setState(() {
          allProducts = loadedItems;

          _isLoaded = false;
        });
      }
    } catch (err) {
      setState(() {
        log(err.toString());
        _erorr = 'Something went wrong.';
        _isLoaded = false;
      });
    }
  }

  Future<void> _deleteProduct(String productId) async {
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    Widget _content = Center(
      child: Text(
        'No Items Added Yet',
        style: GoogleFonts.alef(
          fontWeight: FontWeight.w400,
          fontSize: 18,
        ),
      ),
    );
    if (_erorr != null) {
      _content = Center(
          child: Text(
        _erorr!,
        style: GoogleFonts.alef(
          fontWeight: FontWeight.w400,
          fontSize: 18,
        ),
      ));
    }
    if (_isLoaded) {
      _content = const Center(
        child: CircularProgressIndicator(),
      );
    }
    if (allProducts.isNotEmpty) {
      allProducts.sort((a, b) => b.soldTimes.compareTo(a.soldTimes));
      Top3Products = allProducts.take(3).toList();

      _content = Expanded(
        child: ListView.builder(
          itemBuilder: (ctx, index) {
            Product product = allProducts[index];
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
                          _deleteProduct(product.id); // Call delete function
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
          itemCount: allProducts.length,
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const AddProductScreen();
              }));
            },
            icon: const Icon(Icons.add)),
        title: Text(
          'Admin Home',
          style: GoogleFonts.alef(
            fontWeight: FontWeight.w600,
            fontSize: 25,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              //log(FirebaseAuth.instance.currentUser!.uid);
            },
            icon: Icon(
              Icons.exit_to_app,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                _getData();
                log(allProducts.length.toString());
              });
            },
            icon: Icon(
              Icons.replay,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Text(
              'Best Sellers',
              style: GoogleFonts.alef(
                fontWeight: FontWeight.w600,
                fontSize: 30,
                //color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(
              height: 7,
            ),
            for (Product pro in Top3Products)
              Container(
                margin: const EdgeInsets.all(5),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.blueGrey),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      pro.name,
                      style: GoogleFonts.alef(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Sold Times : ${pro.soldTimes}',
                      style: GoogleFonts.alef(
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    )
                  ],
                ),
              ),
            const SizedBox(
              height: 15,
            ),
            Text(
              'All Products',
              style: GoogleFonts.alef(
                fontWeight: FontWeight.w600,
                fontSize: 30,
                // color: Theme.of(context).colorScheme.primary,
              ),
            ),
            _content,
          ],
        ),
      ),
    );
  }
}
