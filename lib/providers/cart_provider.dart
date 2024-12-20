// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:mobile_app/models/prodect.dart';

// // StateNotifier to manage cart state
// class CartNotifier extends StateNotifier<List<Product>> {
//   CartNotifier()
//       : super([]);

//   void addProduct(Product product) {
//     state = [...state, product];
//   }

//   void removeProduct(Product product) {
//     state = state.where((p) => p != product).toList();
//   }
// }

// // Provider for the cart
// final cartProvider = StateNotifierProvider<CartNotifier, List<Product>>((ref) {
//   return CartNotifier();
// });
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/prodect.dart';

class CartNotifier extends StateNotifier<Map<Product, int>> {
  CartNotifier() : super({});

  // Add a product to the cart or increment its quantity
  void addProduct(Product product) {
    state = {
      ...state,
      product: (state[product] ?? 0) + 1, // Increment the quantity
    };
  }

  // Set a specific quantity for a product
  void setProductQuantity(Product product, int quantity) {
    if (quantity > 0) {
      state = {
        ...state,
        product: quantity, // Set the exact quantity
      };
    } else {
      // Remove the product completely if the quantity is 0
      final updatedState = Map<Product, int>.from(state);
      updatedState.remove(product);
      state = updatedState;
    }
  }

  double totalCost() {
    return state.entries
        .fold(0.0, (sum, entry) => sum + (entry.key.price * entry.value));
  }

  // Remove a product or decrement its quantity
  void removeProduct(Product product) {
    if (state.containsKey(product)) {
      final currentQuantity = state[product]!;
      if (currentQuantity > 1) {
        state = {
          ...state,
          product: currentQuantity - 1, // Decrease the quantity
        };
      } else {
        final updatedState = Map<Product, int>.from(state);
        updatedState.remove(product);
        state = updatedState;
      }
    }
  }

  void removeAllProducts() {
    state = {};
  }
}

final cartProvider =
    StateNotifierProvider<CartNotifier, Map<Product, int>>((ref) {
  return CartNotifier();
});
