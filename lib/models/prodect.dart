import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

class Product {
  final String name;
  final String descreption;
  final String imageLink;
  final Category category;
  final int price;
  final String id;
  double rate = 0;
  int numOfRatings = 10;
  int numInStock;
  final int soldTimes;

  Product({
    required this.id,
    required this.name,
    required this.descreption,
    required this.price,
    required this.imageLink,
    required this.numInStock,
    required this.category,
    required this.rate,
    // required this.numOfRatings,
    required this.soldTimes,
  });

  void rateTheProduct(int rate) {
    double totalRate = this.rate * numOfRatings;
    numOfRatings++;

    this.rate = (rate + totalRate) / numOfRatings;
    userRating(id, this.rate);
  }

  void userRating(String pid, double newRate) async {
    final url = Uri.https('mobile-app-e112c-default-rtdb.firebaseio.com',
        '/product-list/$pid.json');
    try {
      final response = await http.patch(
        url,
        body: json.encode({'rate': newRate}),
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

enum Category { electronics, clothes, furniture, books, toys, sports }

// List<Product> dummyProducts = [
//   Product(
//     id: 'dsafgaadfsgadfsggkuiyuk',
//     numInStock: 2,
//     name: "iphone 12",
//     rate: 1,
//     price: 120,
//     category: Category.electronics,
//     descreption:
//         "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.",
//     imageLink:
//         "https://www.smartcellular.ae/media/catalog/product/cache/44967087533007dde7246873a72eba7b/t/r/tr_9_1.jpg",
//   ),
//   Product(
//     id: 'dsafgaadfsgadfsgdfzrvbn ',
//     name: "labtop",
//     numInStock: 2,
//     category: Category.electronics,
//     price: 120,
//     descreption:
//         "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.",
//     imageLink:
//         "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRKrYe0AQcXQzKYZ4oovVv8Lutl33o7ZM4HBQ&s",
//   ),
//   Product(
//     id: 'dsafgaadfsgadfsgcvfxzgr',
//     numInStock: 2,
//     name: "shhos",
//     category: Category.clothes,
//     price: 120,
//     descreption:
//         "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.",
//     imageLink:
//         "https://www.smartcellular.ae/media/catalog/product/cache/44967087533007dde7246873a72eba7b/t/r/tr_9_1.jpg",
//   ),
//   Product(
//     id: 'dsafgaadfsgadfsghjfku',
//     numInStock: 2,
//     name: "toy",
//     category: Category.toys,
//     price: 120,
//     descreption:
//         "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.",
//     imageLink:
//         "https://www.smartcellular.ae/media/catalog/product/cache/44967087533007dde7246873a72eba7b/t/r/tr_9_1.jpg",
//   ),
//   Product(
//     id: 'dsafgaadfsgadfsgfghjfg',
//     numInStock: 2,
//     name: "toy2",
//     category: Category.toys,
//     price: 120,
//     descreption:
//         "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.",
//     imageLink:
//         "https://www.smartcellular.ae/media/catalog/product/cache/44967087533007dde7246873a72eba7b/t/r/tr_9_1.jpg",
//   ),
// ];
