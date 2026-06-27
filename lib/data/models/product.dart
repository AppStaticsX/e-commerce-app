class ProductColor {
  final String code;
  final String name;

  const ProductColor({required this.code, required this.name});

  factory ProductColor.fromJson(Map<String, dynamic> json) {
    return ProductColor(
      code: json['code'] as String,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
    };
  }
}

class Product {
  final String id;
  final String name;
  final String category;
  final double price;
  final double oldPrice;
  final double rating;
  final int reviewsCount;
  final String description;
  final String imageUrl;
  final String gender;
  final List<String> sizes;
  final List<ProductColor> colors;

  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    this.oldPrice = 0.0,
    required this.rating,
    required this.reviewsCount,
    required this.description,
    required this.imageUrl,
    this.gender = 'All',
    this.sizes = const [],
    this.colors = const [],
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      price: (json['price'] as num).toDouble(),
      oldPrice: (json['oldPrice'] as num?)?.toDouble() ?? 0.0,
      rating: (json['rating'] as num).toDouble(),
      reviewsCount: json['reviewsCount'] as int,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      gender: json['gender'] as String? ?? 'All',
      sizes:
          (json['sizes'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          [],
      colors: (json['colors'] as List<dynamic>?)?.map((e) {
        if (e is String) {
          return ProductColor(code: e, name: 'Color');
        } else if (e is Map<String, dynamic>) {
          return ProductColor.fromJson(e);
        }
        return const ProductColor(code: '', name: '');
      }).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'price': price,
      'oldPrice': oldPrice,
      'rating': rating,
      'reviewsCount': reviewsCount,
      'description': description,
      'imageUrl': imageUrl,
      'gender': gender,
      'sizes': sizes,
      'colors': colors.map((e) => e.toJson()).toList(),
    };
  }
}
