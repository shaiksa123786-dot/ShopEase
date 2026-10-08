import 'package:flutter/material.dart';
import '../models/product.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });

  double get total => product.price * quantity;
}

class CartProvider extends ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => _items;

  int get itemCount {
    return _items.values.fold(
      0,
      (sum, item) => sum + item.quantity,
    );
  }

  double get subtotal {
    return _items.values.fold(
      0.0,
      (sum, item) => sum + item.total,
    );
  }

  double get deliveryFee {
    if (_items.isEmpty) return 0;
    return subtotal >= 500 ? 0 : 49;
  }

  double get discount {
    if (subtotal >= 2000) {
      return subtotal * 0.10;
    }
    return 0;
  }

  double get totalPrice {
    return subtotal + deliveryFee - discount;
  }

  bool containsProduct(String productId) {
    return _items.containsKey(productId);
  }

  int quantityOf(String productId) {
    return _items[productId]?.quantity ?? 0;
  }

  void addToCart(Product product, {int quantity = 1}) {
    if (_items.containsKey(product.id)) {
      _items[product.id]!.quantity += quantity;
    } else {
      _items[product.id] = CartItem(
        product: product,
        quantity: quantity,
      );
    }

    notifyListeners();
  }

  void incrementQuantity(String productId) {
    if (!_items.containsKey(productId)) return;

    _items[productId]!.quantity++;
    notifyListeners();
  }

  void decrementQuantity(String productId) {
    if (!_items.containsKey(productId)) return;

    if (_items[productId]!.quantity > 1) {
      _items[productId]!.quantity--;
    } else {
      _items.remove(productId);
    }

    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}