import 'package:flutter/foundation.dart';

import 'cart_item.dart';
import 'product_model.dart';

/// A simple global cart service for the sample app.
///
/// Uses a [ValueNotifier] so the UI can react to changes without depending on
/// a third-party package.
class CartService {
  CartService._();

  static final ValueNotifier<List<CartItem>> items = ValueNotifier<List<CartItem>>([]);

  static double get total =>
      items.value.fold(0, (sum, item) => sum + item.total);

  static int get totalQuantity =>
      items.value.fold(0, (sum, item) => sum + item.quantity);

  static void add(Product product, {int quantity = 1}) {
    final current = List<CartItem>.from(items.value);
    final index = current.indexWhere((item) => item.product.id == product.id);

    if (index >= 0) {
      final existing = current[index];
      current[index] = CartItem(product: existing.product, quantity: existing.quantity + quantity);
    } else {
      current.add(CartItem(product: product, quantity: quantity));
    }

    items.value = current;
  }

  static void removeAt(int index) {
    final current = List<CartItem>.from(items.value);
    if (index >= 0 && index < current.length) {
      current.removeAt(index);
      items.value = current;
    }
  }

  static void decreaseQuantity(int productId) {
    final current = List<CartItem>.from(items.value);
    final index = current.indexWhere((item) => item.product.id == productId);
    if (index < 0) return;

    final item = current[index];
    if (item.quantity <= 1) {
      current.removeAt(index);
    } else {
      current[index] = CartItem(product: item.product, quantity: item.quantity - 1);
    }

    items.value = current;
  }

  static void increaseQuantity(int productId) {
    final current = List<CartItem>.from(items.value);
    final index = current.indexWhere((item) => item.product.id == productId);
    if (index < 0) return;

    final item = current[index];
    current[index] = CartItem(product: item.product, quantity: item.quantity + 1);
    items.value = current;
  }

  static void clear() {
    items.value = [];
  }
}
