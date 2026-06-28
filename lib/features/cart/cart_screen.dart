import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'cart_provider.dart';
import '../../data/models/product.dart';

import '../../core/widgets/empty_state_view.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/circular_icon_button.dart';
import 'package:loader_overlay/loader_overlay.dart';
import '../../core/widgets/custom_loader_overlay.dart';
import '../../core/widgets/no_internet_widget.dart';
import '../../core/providers/connectivity_provider.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  final TextEditingController _promoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _promoController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasInternetAsync = ref.watch(connectivityProvider);
    final hasInternet = hasInternetAsync.value ?? true;

    final cartItems = ref.watch(cartProvider);
    final notifier = ref.read(cartProvider.notifier);
    final isPromoApplied = ref.watch(promoProvider);

    if (!hasInternet) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            'BAG',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              fontFamily: 'MI',
            ),
          ),
          centerTitle: false,
          automaticallyImplyLeading: false,
          elevation: 4,
          shadowColor: Colors.black.withValues(alpha: 0.3),
          surfaceTintColor: Colors.transparent,
        ),
        body: NoInternetWidget(
          onRetry: () {
            ref.invalidate(connectivityProvider);
          },
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'BAG',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            fontFamily: 'MI',
          ),
        ),
        centerTitle: false,
        automaticallyImplyLeading: false,
        elevation: 4,
        shadowColor: Colors.black.withValues(alpha: 0.3),
        surfaceTintColor: Colors.transparent,
      ),
      body: cartItems.isEmpty
          ? const EmptyStateView(
              icon: Iconsax.shopping_bag_copy,
              title: 'Your Bag Is Empty',
              subtitle: 'There are no products in your bag',
            )
          : Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(24),
                    children: [
                      // Cart Items List
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: cartItems.length,
                        separatorBuilder: (context, index) => const Divider(
                          height: 24,
                          color: Colors.transparent,
                        ),
                        itemBuilder: (context, index) {
                          final item = cartItems[index];
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 90,
                                height: 120,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.grey.shade100,
                                  image: DecorationImage(
                                    image: CachedNetworkImageProvider(
                                      item.product.imageUrl,
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
                                    if (item.product.oldPrice > item.product.price) ...[
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade100,
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              '${((item.product.oldPrice - item.product.price) / item.product.oldPrice * 100).round()}% OFF | SAVE \$${(item.product.oldPrice - item.product.price).toStringAsFixed(2)}',
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.green.shade600,
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () async {
                                              ref.read(loaderMessageProvider.notifier).updateMessage('REMOVING\nFROM CART...');
                                              context.loaderOverlay.show();
                                              await Future.delayed(const Duration(milliseconds: 1500));
                                              if (context.mounted) {
                                                context.loaderOverlay.hide();
                                                notifier.removeCartItem(item);
                                              }
                                            },
                                            child: const Icon(
                                              Iconsax.trash_copy,
                                              size: 20,
                                              color: Colors.redAccent,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        item.product.name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.normal,
                                            ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ] else ...[
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              item.product.name,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.normal,
                                                  ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          GestureDetector(
                                            onTap: () async {
                                              ref.read(loaderMessageProvider.notifier).updateMessage('REMOVING\nFROM CART...');
                                              context.loaderOverlay.show();
                                              await Future.delayed(const Duration(milliseconds: 1500));
                                              if (context.mounted) {
                                                context.loaderOverlay.hide();
                                                notifier.removeCartItem(item);
                                              }
                                            },
                                            child: const Icon(
                                              Iconsax.trash_copy,
                                              size: 20,
                                              color: Colors.redAccent,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],

                                    Text(
                                      '${item.product.colors.firstWhere((c) => c.code == item.color, orElse: () => ProductColor(code: item.color ?? "", name: "Default")).name} - ${item.size ?? "M"}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: Colors.grey.shade600,
                                          ),
                                    ),

                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '\$${item.product.price.toStringAsFixed(2)} USD',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                            ...[
                                              Text(
                                                '\$${item.product.oldPrice.toStringAsFixed(2)} USD',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall
                                                    ?.copyWith(
                                                      decoration: TextDecoration
                                                          .lineThrough,
                                                      color: Colors
                                                          .redAccent
                                                          .shade200,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                              ),
                                            ],
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            CircularIconButton(
                                              icon: Iconsax.minus_copy,
                                              onPressed: () =>
                                                  notifier.decrementQuantity(
                                                    item.product.id,
                                                  ),
                                            ),
                                            const SizedBox(width: 12),
                                            Text(
                                              '${item.quantity}',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.normal,
                                                fontSize: 16,
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            CircularIconButton(
                                              icon: Iconsax.add_copy,
                                              onPressed: () =>
                                                  notifier.incrementQuantity(
                                                    item.product.id,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                      // DISCOUNTS Section
                      Text(
                        'DISCOUNTS',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey.withValues(alpha: 0.3),
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: TextField(
                                controller: _promoController,
                                decoration: const InputDecoration(
                                  hintText: 'ENTER PROMO-CODE',
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          GestureDetector(
                            onTap: _promoController.text.trim().isEmpty || isPromoApplied 
                              ? null 
                              : () {
                                FocusScope.of(context).unfocus();
                                ref.read(promoProvider.notifier).state = true;
                                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text('Promo code applied successfully!', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'MI')),
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  ),
                                );
                              },
                            child: Opacity(
                              opacity: _promoController.text.trim().isEmpty && !isPromoApplied ? 0.5 : 1.0,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 16,
                                ),
                                decoration: BoxDecoration(
                                  color: isPromoApplied ? Theme.of(context).primaryColor : (_promoController.text.trim().isNotEmpty ? Theme.of(context).primaryColor : Colors.grey.shade100),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Text(
                                  isPromoApplied ? 'APPLIED' : 'APPLY',
                                  style: TextStyle(
                                    color: isPromoApplied || _promoController.text.trim().isNotEmpty ? Theme.of(context).scaffoldBackgroundColor : Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(
                            Iconsax.info_circle,
                            size: 16,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Gift Card codes can be applied at checkout.',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 48),

                      // ORDER SUMMARY Section
                      Text(
                        'ORDER SUMMARY',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Subtotal',
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(color: Colors.grey.shade800),
                          ),
                          Text(
                            '\$${notifier.totalAmount.toStringAsFixed(2)} USD',
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(color: Colors.grey.shade800),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Shipping',
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(color: Colors.grey.shade800),
                          ),
                          Text(
                            'Free Standard',
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(color: Colors.grey.shade800),
                          ),
                        ],
                      ),

                      if (isPromoApplied) ...[
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Promo (10% OFF)',
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(color: Colors.green),
                            ),
                            Text(
                              '-\$${(notifier.totalAmount * 0.10).toStringAsFixed(2)} USD',
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(color: Colors.green),
                            ),
                          ],
                        ),
                      ],
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '\$${(isPromoApplied ? notifier.totalAmount * 0.90 : notifier.totalAmount).toStringAsFixed(2)} USD',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24), // minimal padding here
                    ],
                  ),
                ),
                // Fixed Bottom Button
                Container(
                  padding: const EdgeInsets.only(
                    left: 24,
                    right: 24,
                    top: 16,
                    bottom: 100,
                  ), // bottom 100 to clear the main bottom nav
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    border: Border(
                      top: BorderSide(
                        color: Colors.grey.withValues(alpha: 0.1),
                      ),
                    ),
                  ),
                  child: PrimaryButton(
                    text: 'CHECKOUT SECURELY',
                    icon: const Icon(Iconsax.lock),
                    onPressed: () {
                      context.push('/checkout');
                    },
                  ),
                ),
              ],
            ),
    );
  }
}

