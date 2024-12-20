import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_app/models/transaction.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  bool _isLoaded = true;
  String? _erorr;
  List<Transaction> allTransactions = [];

  void _getData() async {
    final url = Uri.https('mobile-app-e112c-default-rtdb.firebaseio.com',
        'transaction-list.json');
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
      final List<Transaction> loadedItems = [];
      for (var item in loadedData.entries) {
        loadedItems.add(Transaction(
            userEmail: item.value['userEmail'] ?? 'u',
            productName: item.value['productName'] ?? 'p',
            quantity: item.value['quantity'] ?? 2,
            date: item.value['date'] ?? 'd'));
        setState(() {
          allTransactions = loadedItems;

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
    if (allTransactions.isNotEmpty) {
      _content = ListView.builder(
        itemBuilder: (ctx, index) {
          Transaction trans = allTransactions[index];
          return Container(
              padding: const EdgeInsets.all(7),
              margin: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: Colors.black12),
              child: ListTile(
                title: Text(
                  trans.productName,
                  style: GoogleFonts.alef(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      color: Color.fromARGB(255, 54, 8, 114)),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Made by user :',
                      style: GoogleFonts.alef(
                        fontWeight: FontWeight.w400,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      trans.userEmail,
                      style: GoogleFonts.alef(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                          color: Color.fromARGB(255, 80, 8, 175)),
                    ),
                    Text(
                      'Date :', // '${trans.userEmail} ${trans.date}',
                      style: GoogleFonts.alef(
                        fontWeight: FontWeight.w400,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      '${trans.date.split('T')[0]}  ${trans.date.split('T')[1].split('.')[0]}',
                      // '${trans.userEmail} ${trans.date}',
                      style: GoogleFonts.alef(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                          color: Color.fromARGB(255, 77, 14, 223)),
                    ),
                  ],
                ),
              ));
        },
        itemCount: allTransactions.length,
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'All Transactions ',
          style: GoogleFonts.alef(
            fontWeight: FontWeight.w800,
            fontSize: 25,
          ),
        ),
        centerTitle: true,
      ),
      body: _content,
    );
  }
}
