import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../../../data/models/product.dart';
import '../../favorites/favorites_provider.dart';

class ProductCard extends ConsumerWidget {
  final Product product;
  final int index;

  const ProductCard({super.key, required this.product, required this.index});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Determine alternating height for masonry effect
    final imageHeight = index.isEven ? 220.0 : 280.0;
    
    final favorites = ref.watch(favoritesProvider);
    final isFav = favorites.any((p) => p.id == product.id);

    return GestureDetector(
      onTap: () => context.push('/details', extra: product),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              Hero(
                tag: 'product_image_${product.id}',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: CachedNetworkImage(
                    imageUrl: product.imageUrl,
                    height: imageHeight,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      height: imageHeight,
                      width: double.infinity,
                      color: Colors.grey.shade100,
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Iconsax.shopping_bag_copy),
                            SizedBox(height: 4),
                            Text(
                              'LOADING...',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      height: imageHeight,
                      width: double.infinity,
                      color: Colors.grey.shade100,
                      child: const Center(
                        child: Icon(Icons.error, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: GestureDetector(
                  onTap: () {
                    ref.read(favoritesProvider.notifier).toggleFavorite(product);
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(isFav ? '"${product.name}" Removed from Wishlist' : '"${product.name}" Added to Wishlist', style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'MI')),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withValues(alpha: 0.7),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isFav ? Iconsax.heart : Iconsax.heart_copy,
                      size: 20,
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            product.name,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w400),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            product.category,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '\$${product.price.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Icon(
                    Iconsax.star_1,
                    size: 16,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    product.rating.toString(),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
