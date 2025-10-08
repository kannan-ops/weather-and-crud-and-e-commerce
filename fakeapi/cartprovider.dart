import 'package:flutter/material.dart';

class CartProduct with ChangeNotifier {
  final List<Map<String, dynamic>> _cart = [];

  List<Map<String, dynamic>> get cart => _cart;

  void addToCart(Map<String, dynamic> product) {
    int index = _cart.indexWhere((item) => item['id'] == product['id']);
    if (index >= 0) {
      _cart[index]['quantity'] += product['quantity'];
    } else {
      _cart.add(product);
    }
    notifyListeners();
  }

  void removeFromCart(int id) {
    _cart.removeWhere((item) => item['id'] == id);
    notifyListeners();
  }

  bool containsProduct(int id) {
    return _cart.any((item) => item['id'] == id);
  }

  void incrementQuantity(int id) {
    int index = _cart.indexWhere((item) => item['id'] == id);
    if (index >= 0) {
      _cart[index]['quantity'] += 1;
      notifyListeners();
    }
  }

  void decrementQuantity(int id) {
    int index = _cart.indexWhere((item) => item['id'] == id);
    if (index >= 0) {
      if (_cart[index]['quantity'] > 1) {
        _cart[index]['quantity'] -= 1;
      } else {
        _cart.removeAt(index);
      }
      notifyListeners();
    }
  }

  double get totalPrice {
    double total = 0.0;
    for (var item in _cart) {
      total += (item['price'] * item['quantity']);
    }
    return total;
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }
}
