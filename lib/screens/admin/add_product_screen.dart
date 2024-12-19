import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import '../../models/prodect.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formkey = GlobalKey<FormState>();
  String _enterdName = '';
  String _enterdImageLink = '';
  String _enterdDescreption = '';
  int _enterdPrice = 0;
  int _enterdNumInStock = 0;
  Category _selectedCategory = Category.electronics;
  bool _isLoaded = false;
  void _saveItem() async {
    if (_formkey.currentState!.validate()) {
      _formkey.currentState!.save();
      setState(() {
        _isLoaded = true;
      });
      final url = Uri.https(
          'mobile-app-e112c-default-rtdb.firebaseio.com', 'product-list.json');
      http
          .post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': _enterdName,
          'price': _enterdPrice,
          'category': _selectedCategory.name,
          'imageLink': _enterdImageLink,
          'descreption': _enterdDescreption,
          'numInStock': _enterdNumInStock,
          'rate': 0.0,
          'soldTimes': 0,
        }),
      )
          .then((res) {
        //final Map<String, dynamic> resData = json.decode(res.body);
        if (res.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'A product with name $_enterdName is added',
                style: GoogleFonts.alef(
                  fontWeight: FontWeight.w400,
                  fontSize: 18,
                ),
              ),
            ),
          );
        }
        setState(() {
          _isLoaded = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formkey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Name'),
                onSaved: (newValue) {
                  _enterdName = newValue!;
                },
                maxLength: 50,
                validator: (val) {
                  if (val == null ||
                      val.isEmpty ||
                      val.trim().length <= 1 ||
                      val.trim().length >= 50) {
                    return 'Must be between 1 and 50 chracters';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 12,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Image Link'),
                onSaved: (newValue) {
                  _enterdImageLink = newValue!;
                },
                validator: (val) {
                  if (val == null || val.isEmpty || val.trim().length <= 1) {
                    return 'Must give an Image Link ';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 12,
              ),
              TextFormField(
                decoration:
                    const InputDecoration(labelText: 'Product Discreption'),
                onSaved: (newValue) {
                  _enterdDescreption = newValue!;
                },
                validator: (val) {
                  if (val == null || val.isEmpty || val.trim().length <= 1) {
                    return 'Must give discreption ';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 12,
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Number in Stock'),
                onSaved: (newValue) {
                  _enterdNumInStock = int.parse(newValue!);
                },
                initialValue: '1',
                validator: (val) {
                  if (val == null ||
                      val.isEmpty ||
                      int.tryParse(val) == null ||
                      int.tryParse(val)! <= 0) {
                    return 'Must be a valid positive number.';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 12,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Price'),
                      onSaved: (newValue) {
                        _enterdPrice = int.parse(newValue!);
                      },
                      initialValue: '1',
                      validator: (val) {
                        if (val == null ||
                            val.isEmpty ||
                            int.tryParse(val) == null ||
                            int.tryParse(val)! <= 0) {
                          return 'Must be a valid positive number.';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: DropdownButtonFormField(
                      key: ValueKey(_selectedCategory),
                      items: [
                        for (final category in Category.values)
                          DropdownMenuItem(
                            value: category,
                            child: Text(
                              category.name,
                              style: GoogleFonts.alef(
                                fontWeight: FontWeight.w400,
                                fontSize: 18,
                              ),
                            ),
                          )
                      ],
                      value: _selectedCategory,
                      onChanged: (val) {
                        setState(() {
                          _selectedCategory = val!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: _isLoaded
                          ? null
                          : () {
                              _formkey.currentState!.reset();
                            },
                      child: Text(
                        'Reset',
                        style: GoogleFonts.alef(
                          fontWeight: FontWeight.w400,
                          fontSize: 18,
                        ),
                      )),
                  const SizedBox(
                    width: 6,
                  ),
                  ElevatedButton(
                      onPressed: _isLoaded ? null : _saveItem,
                      child: _isLoaded
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(),
                            )
                          : Text(
                              'Add Item',
                              style: GoogleFonts.alef(
                                fontWeight: FontWeight.w400,
                                fontSize: 18,
                              ),
                            ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
