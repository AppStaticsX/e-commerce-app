import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'widgets/product_card.dart';
import '../../core/widgets/filter_bottom_sheet.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../data/models/product.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCategory = 'All Items';
  String selectedGender = 'All';
  String selectedSortBy = 'Newest';
  int? selectedDiscount;
  String? selectedSize;
  String? selectedPriceRange = 'All';
  String searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  final List<String> genders = ['All', 'Women', 'Men'];

  List<Product> _products = [];
  List<String> _categories = [];
  List<String> _sizes = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/data/data.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      
      setState(() {
        _categories = (jsonData['categories'] as List<dynamic>).map((e) => e.toString()).toList();
        if (jsonData.containsKey('sizes')) {
          _sizes = (jsonData['sizes'] as List<dynamic>).map((e) => e.toString()).toList();
        }
        _products = (jsonData['products'] as List<dynamic>).map((e) => Product.fromJson(e)).toList();
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading JSON data: $e');
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: Theme.of(context).primaryColor),
        ),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text(
              'Error: $_errorMessage\n\nTry performing a Hot Restart (or completely stop and run the app again) so the new assets are bundled.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red),
            ),
          ),
        ),
      );
    }

    var filteredProducts = _products.where((p) {
      final matchesCategory =
          selectedCategory == 'All Items' ||
          p.category.toLowerCase().contains(selectedCategory.toLowerCase());
      final matchesSearch = p.name.toLowerCase().contains(
        searchQuery.toLowerCase(),
      );
      final matchesGender = selectedGender == 'All' || p.gender == selectedGender;
      
      bool matchesDiscount = true;
      if (selectedDiscount != null) {
        if (p.oldPrice > p.price) {
          final discount = ((p.oldPrice - p.price) / p.oldPrice * 100).round();
          matchesDiscount = discount >= selectedDiscount!; // e.g. if 50%, show 50% or more
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

      return matchesCategory && matchesSearch && matchesGender && matchesDiscount && matchesSize && matchesPrice;
    }).toList();

    if (selectedSortBy == 'Price: Low to High') {
      filteredProducts.sort((a, b) => a.price.compareTo(b.price));
    } else if (selectedSortBy == 'Price: High to Low') {
      filteredProducts.sort((a, b) => b.price.compareTo(a.price));
    } else if (selectedSortBy == 'Newest') {
      // Mock newest by reversing the list
      filteredProducts = filteredProducts.reversed.toList();
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              // App Bar Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello, Welcome 👋'.toUpperCase(),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Albert Stevano'.toUpperCase(),
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                  const CircleAvatar(
                    radius: 20,
                    backgroundImage: CachedNetworkImageProvider(
                      'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?ixlib=rb-4.0.3&auto=format&fit=crop&w=200&q=80',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Search Bar
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardTheme.color,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.grey.withValues(alpha: 0.2),
                        ),
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (value) {
                          setState(() {
                            searchQuery = value;
                          });
                        },
                        decoration: const InputDecoration(
                          hintText: 'Search clothes...',
                          border: InputBorder.none,
                          icon: Icon(
                            Iconsax.search_normal_1_copy,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) {
                          // Extract unique discount values
                          final Set<int> discounts = {};
                          for (var p in _products) {
                            if (p.oldPrice > p.price) {
                              discounts.add(((p.oldPrice - p.price) / p.oldPrice * 100).round());
                            }
                          }
                          // Since they want 50%, 60%, 70% in the mock, we can hardcode 
                          // or just use what we extracted. Let's merge them to ensure UI has mock data if empty.
                          final availableDiscounts = {50, 60, 70, ...discounts}.toList()..sort();
                          
                          // Use the sizes directly from data.json
                          final availableSizes = _sizes.isNotEmpty ? _sizes : ['XS', 'S', 'M', 'L', 'XL', 'XXL'];
                          
                          return FilterBottomSheet(
                            initialSortBy: selectedSortBy,
                            initialGender: selectedGender,
                            initialDiscount: selectedDiscount,
                            initialSize: selectedSize,
                            initialPriceRange: selectedPriceRange,
                            availableGenders: genders,
                            availableDiscounts: availableDiscounts,
                            availableSizes: availableSizes,
                            onApply: (newSort, newGender, newDiscount, newSize, newPriceRange) {
                              setState(() {
                                selectedSortBy = newSort;
                                selectedGender = newGender;
                                selectedDiscount = newDiscount;
                                selectedSize = newSize;
                                selectedPriceRange = newPriceRange;
                              });
                            },
                          );
                        },
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        Iconsax.setting_4_copy,
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Categories
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _categories.map((category) {
                    final isSelected = selectedCategory == category;
                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedCategory = category;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Theme.of(context).primaryColor
                                : Theme.of(context).scaffoldBackgroundColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SvgPicture.asset(
                                _getCategorySvg(category),
                                width: 20,
                                height: 20,
                                colorFilter: ColorFilter.mode(
                                  isSelected
                                      ? Theme.of(
                                          context,
                                        ).scaffoldBackgroundColor
                                      : Theme.of(context).primaryColor,
                                  BlendMode.srcIn,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                category,
                                style: TextStyle(
                                  color: isSelected
                                      ? Theme.of(
                                          context,
                                        ).scaffoldBackgroundColor
                                      : Theme.of(context).primaryColor,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 24),

              // Product Grid
              Expanded(
                child: MasonryGridView.count(
                  padding: const EdgeInsets.only(bottom: 24),
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  itemCount: filteredProducts.length,
                  itemBuilder: (context, index) {
                    final product = filteredProducts[index];
                    return ProductCard(product: product, index: index);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



String _getCategorySvg(String category) {
  switch (category) {
    case 'All Items':
      return 'assets/icon/categories/cat_all.svg';
    case 'T-Shirt':
      return 'assets/icon/categories/cat_shirt.svg';
    case 'Dress':
      return 'assets/icon/categories/cat_dress.svg';
    case 'Pants':
      return 'assets/icon/categories/cat_pant.svg';
    case 'Accessories':
      return 'assets/icon/categories/cat_accessories.svg';
    case 'Shocks':
      return 'assets/icon/categories/cat_shocks.svg';
    default:
      return 'assets/icon/categories/cat_all.svg';
  }
}

/*String _getGenderSvg(String gender) {
  switch (gender) {
    case 'All': return 'assets/icon/gender/gen_all.svg';
    case 'Women': return 'assets/icon/gender/gen_female.svg';
    case 'Men': return 'assets/icon/gender/gen_male.svg';
    default: return 'assets/icon/gender/gen_all.svg';
  }
}*/
