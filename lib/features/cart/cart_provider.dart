import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../data/models/product.dart';

class CartItem {
  final Product product;
  int quantity;
  final String? size;
  final String? color;

  CartItem({required this.product, this.quantity = 1, this.size, this.color});

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      product: Product.fromJson(json['product'] as Map<String, dynamic>),
      quantity: json['quantity'] as int,
      size: json['size'] as String?,
      color: json['color'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'quantity': quantity,
      'size': size,
      'color': color,
    };
  }
}

class CartNotifier extends Notifier<List<CartItem>> {
  @override
  List<CartItem> build() {
    final cartBox = Hive.box('cart');
    final cartData = cartBox.get('cart_items') as List<dynamic>?;
    if (cartData != null) {
      return cartData.map((e) => CartItem.fromJson(jsonDecode(e as String))).toList();
    }
    return [];
  }

  void _saveToHive() {
    final cartBox = Hive.box('cart');
    final encodedData = state.map((e) => jsonEncode(e.toJson())).toList();
    cartBox.put('cart_items', encodedData);
  }

  void addProduct(Product product, int quantity, {String? size, String? color}) {
    final existingIndex = state.indexWhere((item) => item.product.id == product.id && item.size == size && item.color == color);
    if (existingIndex >= 0) {
      final updatedList = [...state];
      updatedList[existingIndex].quantity += quantity;
      state = updatedList;
    } else {
      state = [...state, CartItem(product: product, quantity: quantity, size: size, color: color)];
    }
    _saveToHive();
  }

  void removeCartItem(CartItem itemToRemove) {
    state = state.where((item) => item != itemToRemove).toList();
    _saveToHive();
  }

  void incrementQuantity(String productId) {
    final updatedList = [...state];
    final index = updatedList.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      updatedList[index].quantity += 1;
      state = updatedList;
      _saveToHive();
    }
  }

  void decrementQuantity(String productId) {
    final updatedList = [...state];
    final index = updatedList.indexWhere((item) => item.product.id == productId);
    if (index >= 0 && updatedList[index].quantity > 1) {
      updatedList[index].quantity -= 1;
      state = updatedList;
      _saveToHive();
    }
  }

  double get totalAmount {
    return state.fold(0, (total, item) => total + (item.product.price * item.quantity));
  }
  
  int get totalItems {
    return state.fold(0, (total, item) => total + item.quantity);
  }

  void clearCart() {
    state = [];
    _saveToHive();
  }
}

final cartProvider = NotifierProvider<CartNotifier, List<CartItem>>(CartNotifier.new);

final promoProvider = StateProvider<bool>((ref) => false);
