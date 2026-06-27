import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../data/models/product.dart';

class FavoritesNotifier extends Notifier<List<Product>> {
  @override
  List<Product> build() {
    final favoritesBox = Hive.box('favorites');
    final favoritesData = favoritesBox.get('items') as List<dynamic>?;
    if (favoritesData != null) {
      return favoritesData.map((e) => Product.fromJson(jsonDecode(e as String))).toList();
    }
    return [];
  }

  void _saveToHive() {
    final favoritesBox = Hive.box('favorites');
    final encodedData = state.map((e) => jsonEncode(e.toJson())).toList();
    favoritesBox.put('items', encodedData);
  }

  void toggleFavorite(Product product) {
    final isFavorite = state.any((p) => p.id == product.id);
    if (isFavorite) {
      state = state.where((p) => p.id != product.id).toList();
    } else {
      state = [...state, product];
    }
    _saveToHive();
  }
  
  bool isFavorite(String id) {
    return state.any((p) => p.id == id);
  }
}

final favoritesProvider = NotifierProvider<FavoritesNotifier, List<Product>>(() {
  return FavoritesNotifier();
});
