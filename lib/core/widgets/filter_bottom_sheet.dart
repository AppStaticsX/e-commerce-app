import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class FilterBottomSheet extends StatefulWidget {
  final String initialSortBy;
  final String initialGender;
  final int? initialDiscount;
  final String? initialSize;
  final String? initialPriceRange;
  final List<String> availableGenders;
  final List<int> availableDiscounts;
  final List<String> availableSizes;
  final Function(String, String, int?, String?, String?) onApply;

  const FilterBottomSheet({
    super.key,
    required this.initialSortBy,
    required this.initialGender,
    this.initialDiscount,
    this.initialSize,
    this.initialPriceRange,
    required this.availableGenders,
    required this.availableDiscounts,
    required this.availableSizes,
    required this.onApply,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  final List<String> filters = [
    'SORT BY',
    'GENDER',
    'SIZE',
    'DISCOUNT',
    'PRICE',
  ];

  String? expandedFilter;
  late String selectedSort;
  late String selectedGender;
  int? selectedDiscount;
  String? selectedSize;
  String? selectedPriceRange;

  @override
  void initState() {
    super.initState();
    selectedSort = widget.initialSortBy;
    selectedGender = widget.initialGender;
    selectedDiscount = widget.initialDiscount;
    selectedSize = widget.initialSize;
    selectedPriceRange = widget.initialPriceRange ?? 'All';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close, size: 24),
                ),
                const Text(
                  'FILTER & SORT',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    'Clear All',
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: Colors.grey.shade200),
          
          // Filter List
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.zero,
              itemCount: filters.length,
              separatorBuilder: (context, index) => Divider(height: 1, color: Colors.grey.shade100),
              itemBuilder: (context, index) {
                final filter = filters[index];
                final isExpanded = expandedFilter == filter;

                return Column(
                  children: [
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 4.0),
                      title: Text(
                        filter,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      trailing: Icon(
                        isExpanded ? Iconsax.arrow_up_2_copy : Iconsax.arrow_down_1_copy,
                        color: Colors.grey.shade700,
                      ),
                      onTap: () {
                        setState(() {
                          expandedFilter = isExpanded ? null : filter;
                        });
                      },
                    ),
                    if (isExpanded && filter == 'SORT BY')
                      Padding(
                        padding: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 16.0, top: 8.0),
                        child: Wrap(
                          spacing: 16,
                          runSpacing: 16,
                          children: ['Price: Low to High', 'Price: High to Low', 'Newest'].map((sortOption) {
                            final isSelected = selectedSort == sortOption;
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedSort = sortOption;
                                });
                              },
                              child: Container(
                                width: (MediaQuery.of(context).size.width - 48 - 16) / 2, // 2 columns
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                decoration: BoxDecoration(
                                  color: isSelected ? Colors.black : Colors.white,
                                  border: Border.all(
                                    color: isSelected ? Colors.black : Colors.black87,
                                    width: 1.5,
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  sortOption,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                    color: isSelected ? Colors.white : Colors.black,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    if (isExpanded && filter == 'GENDER')
                      Padding(
                        padding: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 16.0, top: 8.0),
                        child: Wrap(
                          spacing: 16,
                          runSpacing: 16,
                          children: widget.availableGenders.map((gender) {
                            final isSelected = selectedGender == gender;
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedGender = gender;
                                });
                              },
                              child: Container(
                                width: (MediaQuery.of(context).size.width - 48 - 16) / 2, // 2 columns
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                decoration: BoxDecoration(
                                  color: isSelected ? Colors.black : Colors.white,
                                  border: Border.all(
                                    color: isSelected ? Colors.black : Colors.black87,
                                    width: 1.5,
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  gender,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                    color: isSelected ? Colors.white : Colors.black,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    if (isExpanded && filter == 'DISCOUNT')
                      Padding(
                        padding: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 16.0, top: 8.0),
                        child: Wrap(
                          spacing: 16,
                          runSpacing: 16,
                          children: widget.availableDiscounts.map((discount) {
                            final isSelected = selectedDiscount == discount;
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedDiscount = isSelected ? null : discount;
                                });
                              },
                              child: Container(
                                width: (MediaQuery.of(context).size.width - 48 - 16) / 2, // 2 columns
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                decoration: BoxDecoration(
                                  color: isSelected ? Colors.black : Colors.white,
                                  border: Border.all(
                                    color: isSelected ? Colors.black : Colors.black87,
                                    width: 1.5,
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  '$discount%',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                    color: isSelected ? Colors.white : Colors.black,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    if (isExpanded && filter == 'SIZE')
                      Padding(
                        padding: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 16.0, top: 8.0),
                        child: Wrap(
                          spacing: 16,
                          runSpacing: 16,
                          children: widget.availableSizes.map((size) {
                            final isSelected = selectedSize == size;
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedSize = isSelected ? null : size;
                                });
                              },
                              child: Container(
                                width: (MediaQuery.of(context).size.width - 48 - 16) / 2, // 2 columns
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                decoration: BoxDecoration(
                                  color: isSelected ? Colors.black : Colors.white,
                                  border: Border.all(
                                    color: isSelected ? Colors.black : Colors.black87,
                                    width: 1.5,
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  size,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                    color: isSelected ? Colors.white : Colors.black,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    if (isExpanded && filter == 'PRICE')
                      Padding(
                        padding: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 16.0, top: 8.0),
                        child: Wrap(
                          spacing: 16,
                          runSpacing: 16,
                          children: ['All', 'Under \$50', '\$50 - \$100', '\$100 - \$200', 'Over \$200'].map((priceRange) {
                            final isSelected = selectedPriceRange == priceRange;
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedPriceRange = priceRange;
                                });
                              },
                              child: Container(
                                width: (MediaQuery.of(context).size.width - 48 - 16) / 2, // 2 columns
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                decoration: BoxDecoration(
                                  color: isSelected ? Colors.black : Colors.white,
                                  border: Border.all(
                                    color: isSelected ? Colors.black : Colors.black87,
                                    width: 1.5,
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  priceRange,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                    color: isSelected ? Colors.white : Colors.black,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),

          // Bottom Button
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    widget.onApply(selectedSort, selectedGender, selectedDiscount, selectedSize, selectedPriceRange);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'SEE PRODUCTS',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
