import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../../core/widgets/empty_state_view.dart';
import '../../core/widgets/filter_bottom_sheet.dart';
import 'favorites_provider.dart';
import '../products/widgets/product_card.dart';
import '../../data/models/product.dart';
import '../../core/widgets/no_internet_widget.dart';
import '../../core/providers/connectivity_provider.dart';

class FavoritesScreen extends ConsumerStatefulWidget {
  const FavoritesScreen({super.key});

  @override
  ConsumerState<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends ConsumerState<FavoritesScreen> {
  String selectedSortBy = 'Newest';
  String selectedGender = 'All';
  int? selectedDiscount;
  String? selectedSize;
  String? selectedPriceRange = 'All';

  final List<String> genders = ['All', 'Women', 'Men'];
  final List<int> standardDiscounts = [50, 60, 70];
  final List<String> standardSizes = ['XS', 'S', 'M', 'L', 'XL', 'XXL', '24', '26', '28', '30', '32', '34', '36'];

  @override
  Widget build(BuildContext context) {
    final hasInternetAsync = ref.watch(connectivityProvider);
    final hasInternet = hasInternetAsync.value ?? true;

    if (!hasInternet) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            'WISHLIST',
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

    final favorites = ref.watch(favoritesProvider);

    // Apply filtering
    List<Product> filteredFavorites = favorites.where((p) {
      final matchesGender = selectedGender == 'All' || p.gender == selectedGender || p.gender == 'All';
      
      bool matchesDiscount = true;
      if (selectedDiscount != null) {
        if (p.oldPrice > p.price) {
          final discount = ((p.oldPrice - p.price) / p.oldPrice * 100).round();
          matchesDiscount = discount >= selectedDiscount!;
        } else {
          matchesDiscount = false;
        }
      }

      bool matchesSize = true;
      if (selectedSize != null) {
        matchesSize = p.sizes.contains(selectedSize!);
      }

      bool matchesPrice = true;
      if (selectedPriceRange != null && selectedPriceRange != 'All') {
        if (selectedPriceRange == 'Under \$50') {
          matchesPrice = p.price < 50;
        } else if (selectedPriceRange == '\$50 - \$100') {
          matchesPrice = p.price >= 50 && p.price <= 100;
        } else if (selectedPriceRange == '\$100 - \$200') {
          matchesPrice = p.price > 100 && p.price <= 200;
        } else if (selectedPriceRange == 'Over \$200') {
          matchesPrice = p.price > 200;
        }
      }

      return matchesGender && matchesDiscount && matchesSize && matchesPrice;
    }).toList();

    // Apply sorting
    if (selectedSortBy == 'Price: Low to High') {
      filteredFavorites.sort((a, b) => a.price.compareTo(b.price));
    } else if (selectedSortBy == 'Price: High to Low') {
      filteredFavorites.sort((a, b) => b.price.compareTo(a.price));
    } else if (selectedSortBy == 'Newest') {
      filteredFavorites.sort((a, b) => int.parse(b.id).compareTo(int.parse(a.id)));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'WISHLIST',
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
        actions: [
          if (favorites.isNotEmpty)
            IconButton(
              icon: const Icon(Iconsax.setting_4_copy),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => FilterBottomSheet(
                    initialSortBy: selectedSortBy,
                    initialGender: selectedGender,
                    initialDiscount: selectedDiscount,
                    initialSize: selectedSize,
                    initialPriceRange: selectedPriceRange,
                    availableGenders: genders,
                    availableDiscounts: standardDiscounts,
                    availableSizes: standardSizes,
                    onApply: (newSort, newGender, newDiscount, newSize, newPriceRange) {
                      setState(() {
                        selectedSortBy = newSort;
                        selectedGender = newGender;
                        selectedDiscount = newDiscount;
                        selectedSize = newSize;
                        selectedPriceRange = newPriceRange;
                      });
                    },
                  ),
                );
              },
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: favorites.isEmpty
          ? const EmptyStateView(
              icon: Iconsax.heart,
              title: 'Your Wishlist Is Empty',
              subtitle: 'Any items that you save while browsing will be added here',
            )
          : filteredFavorites.isEmpty 
              ? Center(
                  child: Text(
                    'No favorites match your filters',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 16,
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: MasonryGridView.count(
                    padding: const EdgeInsets.only(top: 24, bottom: 100),
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    itemCount: filteredFavorites.length,
                    itemBuilder: (context, index) {
                      final product = filteredFavorites[index];
                      return ProductCard(product: product, index: index);
                    },
                  ),
                ),
    );
  }
}
