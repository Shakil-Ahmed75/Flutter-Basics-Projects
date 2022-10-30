import 'package:flutter/foundation.dart';
import 'package:flutter_04_05/models/product_model.dart';

class CartProvider extends ChangeNotifier {
  List<Product> _cartItems = [];
  List<Product> get cartItems => _cartItems;

  void addToCart(Product product) {
    _cartItems.add(product);
    notifyListeners();
  }

  void removeAll() {
    _cartItems.clear();
    notifyListeners();
  }

  int get itemCount => _cartItems.length;

  double get totalPrice {
    var total = 0.0;
    _cartItems.forEach((product) {
      total += product.price;
    });
    return total;
  }
}