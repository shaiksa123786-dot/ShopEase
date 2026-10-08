import 'package:flutter/material.dart';
import '../models/product.dart';

class WishlistProvider extends ChangeNotifier {
  final Map<String, Product> _wishlist = {};

  Map<String, Product> get wishlist => _wishlist;

  Set<String> get wishlistIds => _wishlist.keys.toSet();

  bool isWishlisted(String productId) {
    return _wishlist.containsKey(productId);
  }

  Product? getProduct(String productId) {
    return _wishlist[productId];
  }

  void toggleWishlist(Product product) {
    if (_wishlist.containsKey(product.id)) {
      _wishlist.remove(product.id);
    } else {
      _wishlist[product.id] = product;
    }

    notifyListeners();
  }

  void removeFromWishlist(String productId) {
    _wishlist.remove(productId);
    notifyListeners();
  }

  void clearWishlist() {
    _wishlist.clear();
    notifyListeners();
  }
}