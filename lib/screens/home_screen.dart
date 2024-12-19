import 'dart:convert';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import 'package:image_picker/image_picker.dart';
import 'package:mobile_app/models/prodect.dart';
import 'package:mobile_app/size_config.dart';
import 'package:mobile_app/widgets/product_card.dart';
import 'package:http/http.dart' as http;

import 'product_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Product> showenProducts = [];
  List<Product> allProducts = [];
  int? selectedCategory;
  bool _isLoaded = true;
  String? _erorr;

  String? audioPath;

  //final AudioRecorder _record = AudioRecorder();
  bool _isListening = false;
  stt.SpeechToText _speech = stt.SpeechToText();
  String _RecorededText = '';

  final TextEditingController controller = TextEditingController();

  void _getData() async {
    final url = Uri.https(
        'mobile-app-e112c-default-rtdb.firebaseio.com', 'product-list.json');
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
          showenProducts = allProducts;
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

  final List<String> categortis = [
    'All',
    'electronics',
    'clothes',
    'furniture',
    'books',
    'toys',
    'sports'
  ];

  @override
  void initState() {
    super.initState();
    _getData();
    controller.addListener(_filterSearchResults);
  }

  void _filterSearchResults() {
    setState(() {
      showenProducts = allProducts
          .where((pro) =>
              pro.name.toLowerCase().contains(controller.text.toLowerCase()))
          .toList();
    });
  }

  void listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() {
          _isListening = true;
        });
        _speech.listen(onResult: (val) {
          setState(() {
            _RecorededText = val.recognizedWords;

            showenProducts = allProducts
                .where((pro) => pro.name
                    .toLowerCase()
                    .contains(_RecorededText.toLowerCase()))
                .toList();
          });
        });
      }
    } else {
      setState(() {
        _isListening = false;
      });
      _speech.stop();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
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
      _content = Expanded(
        child: ListView.builder(
          itemBuilder: (ctx, index) {
            return ProductCard(product: showenProducts[index]);
          },
          itemCount: showenProducts.length,
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Shoping Home',
          style: GoogleFonts.alef(
            fontWeight: FontWeight.w700,
            fontSize: 24,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              // log(FirebaseAuth.instance.currentUser!.uid);
            },
            icon: Icon(
              Icons.exit_to_app,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Row(
            children: [
              // MyInputField(
              //   hint: _text,
              //   widget: const Icon(
              //     Icons.search,
              //     size: 30,
              //     color: Colors.black54,
              //   ),
              // ),
              Expanded(
                child: Container(
                  //padding: EdgeInsets.all(20),
                  margin: const EdgeInsets.all(14),
                  child: Container(
                    padding: const EdgeInsets.only(left: 14),
                    margin: const EdgeInsets.only(top: 8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey)),
                    height: 52,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: controller,
                            autofocus: false,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Colors.black,
                            ),
                            // readOnly: readOnly,
                            decoration: InputDecoration(
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(width: 0),
                              ),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(width: 0),
                              ),
                              hintText: _RecorededText == ''
                                  ? 'Search By Name'
                                  : _RecorededText,
                              hintStyle: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                        // search icon here
                      ],
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: () async {
                  final XFile? pickedImage = await ImagePicker().pickImage(
                      source: ImageSource.camera,
                      maxWidth: 150,
                      imageQuality: 50);

                  if (pickedImage == null) {
                    return;
                  }
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) => ProductScreen(product: allProducts[0]),
                    ),
                  );
                },
                icon: Icon(
                  Icons.camera,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.mic),
                color: Theme.of(context).colorScheme.primary,
                iconSize: 30,
                onPressed: () {
                  setState(() {
                    listen();
                  });
                },
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            width: SizeConfig.screenWidth,
            height: 70,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemBuilder: (ctx, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  child: GestureDetector(
                    onTap: () {
                      if (index != 0) {
                        setState(() {
                          selectedCategory = index;
                          showenProducts = allProducts
                              .where((pro) =>
                                  categortis[index].trim().toLowerCase() ==
                                  pro.category.name)
                              .toList();
                        });
                      } else {
                        setState(() {
                          selectedCategory = index;
                          showenProducts = allProducts;
                        });
                      }
                    },
                    child: Text(
                      categortis[index],
                      style: GoogleFonts.alef(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        color: selectedCategory == null || selectedCategory == 0
                            ? Theme.of(context).colorScheme.primary
                            : selectedCategory == index
                                ? Theme.of(context).colorScheme.primary
                                : Colors.grey,
                      ),
                      // style: TextStyle(
                      //   fontWeight: FontWeight.w600,
                      //   fontSize: 20,

                      // ),
                    ),
                  ),
                );
              },
              itemCount: categortis.length,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          _content
        ],
      ),
    );
  }
}
