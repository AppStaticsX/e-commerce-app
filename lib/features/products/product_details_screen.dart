import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../../data/models/product.dart';
import '../cart/cart_provider.dart';
import '../favorites/favorites_provider.dart';
import '../../core/widgets/circular_icon_button.dart';
import '../../core/widgets/primary_button.dart';
import 'package:loader_overlay/loader_overlay.dart';
import '../../core/widgets/custom_loader_overlay.dart';

class ProductDetailsScreen extends ConsumerStatefulWidget {
  final Product product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  ConsumerState<ProductDetailsScreen> createState() =>
      _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends ConsumerState<ProductDetailsScreen> {
  String? selectedSize;
  String? selectedColor;
  int quantity = 1;
  bool isDescriptionExpanded = false;

  @override
  void initState() {
    super.initState();
    if (widget.product.sizes.isNotEmpty) {
      selectedSize = widget.product.sizes.first;
    }
    if (widget.product.colors.isNotEmpty) {
      selectedColor = widget.product.colors.first.code;
    }
  }

  @override
  Widget build(BuildContext context) {
    final favorites = ref.watch(favoritesProvider);
    final isFav = favorites.any((p) => p.id == widget.product.id);

    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image
                Hero(
                  tag: 'product_image_${widget.product.id}',
                  child: Container(
                    height: 400,
                    margin: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top + 16,
                      left: 24,
                      right: 24,
                    ),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(
                          widget.product.imageUrl,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title and Quantity
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.product.name.toUpperCase(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Text(
                                      '\$${widget.product.price.toStringAsFixed(2)}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(
                                            color: Theme.of(
                                              context,
                                            ).primaryColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    if (widget.product.oldPrice > 0) ...[
                                      const SizedBox(width: 8),
                                      Text(
                                        '\$${widget.product.oldPrice.toStringAsFixed(2)}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(
                                              decoration:
                                                  TextDecoration.lineThrough,
                                              color: Colors.grey,
                                            ),
                                      ),
                                    ],
                                    const Spacer(),
                                    Row(
                                      children: [
                                        CircularIconButton(
                                          icon: Iconsax.minus_copy,
                                          onPressed: () {
                                            if (quantity > 1) {
                                              setState(() => quantity--);
                                            }
                                          },
                                        ),
                                        const SizedBox(width: 16),
                                        Text(
                                          '$quantity',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        CircularIconButton(
                                          icon: Iconsax.add_copy,
                                          onPressed: () {
                                            setState(() => quantity++);
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Rating and Reviews
                      Row(
                        children: [
                          Icon(
                            Iconsax.star,
                            color: Theme.of(context).colorScheme.secondary,
                            size: 20,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${widget.product.rating}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '(${widget.product.reviewsCount} reviews)',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: Colors.lightBlue),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Description
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.product.description,
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.copyWith(height: 1.5),
                            maxLines: isDescriptionExpanded ? null : 3,
                            overflow: isDescriptionExpanded
                                ? TextOverflow.visible
                                : TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isDescriptionExpanded = !isDescriptionExpanded;
                              });
                            },
                            child: Text(
                              isDescriptionExpanded
                                  ? 'Read Less..'
                                  : 'Read More..',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Attributes Selection
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Sizes
                          if (widget.product.sizes.isNotEmpty)
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Choose Size',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 12),
                                  Wrap(
                                    spacing: 8,
                                    children: widget.product.sizes.map((size) {
                                      final isSelected = selectedSize == size;
                                      return GestureDetector(
                                        onTap: () =>
                                            setState(() => selectedSize = size),
                                        child: Container(
                                          width: 40,
                                          height: 40,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: isSelected
                                                ? Theme.of(context).primaryColor
                                                : Theme.of(
                                                    context,
                                                  ).scaffoldBackgroundColor,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: isSelected
                                                  ? Theme.of(
                                                      context,
                                                    ).primaryColor
                                                  : Colors.grey.withValues(
                                                      alpha: 0.3,
                                                    ),
                                            ),
                                          ),
                                          child: Text(
                                            size,
                                            style: TextStyle(
                                              color: isSelected
                                                  ? Theme.of(
                                                      context,
                                                    ).scaffoldBackgroundColor
                                                  : Theme.of(
                                                      context,
                                                    ).primaryColor,
                                              fontWeight: isSelected
                                                  ? FontWeight.bold
                                                  : FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                            ),
                          // Colors
                          if (widget.product.colors.isNotEmpty)
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Color',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 12),
                                  Wrap(
                                    spacing: 8,
                                    children: widget.product.colors.map((
                                      productColor,
                                    ) {
                                      final colorHex = productColor.code;
                                      final color = Color(
                                        int.parse(
                                          colorHex.replaceAll('#', '0xFF'),
                                        ),
                                      );
                                      final isSelected =
                                          selectedColor == colorHex;
                                      return GestureDetector(
                                        onTap: () => setState(
                                          () => selectedColor = colorHex,
                                        ),
                                        child: Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: color,
                                            shape: BoxShape.circle,
                                            border: isSelected
                                                ? Border.all(
                                                    color: Theme.of(
                                                      context,
                                                    ).colorScheme.secondary,
                                                    width: 2,
                                                  )
                                                : null,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Custom App Bar overlays
          Positioned(
            top: MediaQuery.of(context).padding.top + 32,
            left: 32,
            child: CircleAvatar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              child: IconButton(
                icon: Icon(
                  Iconsax.arrow_left_copy,
                  color: Theme.of(context).primaryColor,
                ),
                onPressed: () => context.pop(),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 32,
            right: 32,
            child: CircleAvatar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              child: IconButton(
                icon: Icon(
                  isFav ? Iconsax.heart : Iconsax.heart_copy,
                  color: Theme.of(context).primaryColor,
                ),
                onPressed: () {
                  ref
                      .read(favoritesProvider.notifier)
                      .toggleFavorite(widget.product);
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isFav
                            ? '"${widget.product.name}" Removed from Wishlist'
                            : '"${widget.product.name}" Added to Wishlist',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'MI',
                        ),
                      ),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      // Bottom Add to Cart Bar
      bottomSheet: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: PrimaryButton(
          text: 'ADD TO BAG',
          icon: const Icon(Iconsax.shopping_bag),
          onPressed: () async {
            ref
                .read(loaderMessageProvider.notifier)
                .updateMessage('ADDING\nITEM TO CART...');
            context.loaderOverlay.show();
            await Future.delayed(const Duration(milliseconds: 1500));
            if (context.mounted) {
              context.loaderOverlay.hide();
              ref
                  .read(cartProvider.notifier)
                  .addProduct(
                    widget.product,
                    quantity,
                    size: selectedSize,
                    color: selectedColor,
                  );
              _showAddedToCartBottomSheet(context, selectedSize, selectedColor);
            }
          },
        ),
      ),
    );
  }

  void _showAddedToCartBottomSheet(
    BuildContext context,
    String? size,
    String? color,
  ) {
    String colorName = 'Black';
    if (color != null) {
      try {
        colorName = widget.product.colors
            .firstWhere((c) => c.code == color)
            .name;
      } catch (_) {}
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 24.0,
            right: 24.0,
            top: 16.0,
            bottom: MediaQuery.of(context).padding.bottom + 24.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: Color(0xFF2E7D32),
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'ITEM ADDED',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'MI',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 100,
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(
                          widget.product.imageUrl,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (widget.product.oldPrice > 0)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            margin: const EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '${((1 - widget.product.price / widget.product.oldPrice) * 100).round()}% OFF',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        Text(
                          widget.product.name,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w500),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),

                        Text(
                          '${widget.product.category} Fit - $colorName',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Colors.grey.shade500),
                        ),
                        if (size != null) ...[
                          
                          Text(
                            'Size: $size',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: Colors.grey.shade500),
                          ),
                        ],
                        Row(
                          children: [
                            Text(
                              '\$${widget.product.price.toStringAsFixed(2)} USD',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            if (widget.product.oldPrice > 0) ...[
                              const SizedBox(width: 8),
                              Text(
                                '\$${widget.product.oldPrice.toStringAsFixed(2)} USD',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      decoration: TextDecoration.lineThrough,
                                      color: Colors.red.shade400,
                                    ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              PrimaryButton(
                text: 'VIEW BAG',
                onPressed: () {
                  Navigator.pop(context);
                  context.go('/cart');
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
