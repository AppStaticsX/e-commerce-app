import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loader_overlay/loader_overlay.dart';
import '../../core/widgets/custom_loader_overlay.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../cart/cart_provider.dart';
import '../../core/widgets/primary_button.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _useExistingAddress = true;
  int _selectedPaymentMethod = 1;

  @override
  Widget build(BuildContext context) {
    final cartNotifier = ref.watch(cartProvider.notifier);

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'CHECKOUT',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            fontFamily: 'MI',
          ),
        ),
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left_copy),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 4,
        shadowColor: Colors.black.withValues(alpha: 0.3),
        surfaceTintColor: Colors.transparent,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                      ?.copyWith(color: isDark ? Colors.grey.shade300 : Colors.grey.shade800),
                ),
                Text(
                  '\$${cartNotifier.totalAmount.toStringAsFixed(2)} USD',
                  style: Theme.of(context).textTheme.bodyLarge
                      ?.copyWith(color: isDark ? Colors.grey.shade300 : Colors.grey.shade800),
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
                      ?.copyWith(color: isDark ? Colors.grey.shade300 : Colors.grey.shade800),
                ),
                Text(
                  'Free Standard',
                  style: Theme.of(context).textTheme.bodyLarge
                      ?.copyWith(color: isDark ? Colors.grey.shade300 : Colors.grey.shade800),
                ),
              ],
            ),
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
                  '\$${cartNotifier.totalAmount.toStringAsFixed(2)} USD',
                  style: Theme.of(context).textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 32),
            
            // Payment Methods
            _buildPaymentMethods(),
            const SizedBox(height: 32),
            
            // Full Name
            TextFormField(
              decoration: _inputDecoration(
                label: 'NAME ON CARD', 
                hint: 'Tom Hanks',
                prefixIcon: Icon(Iconsax.user_copy, size: 20, color: Colors.grey.shade600,),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter name on card';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            
            // Complete (Card Number)
            TextFormField(
              keyboardType: TextInputType.number,
              inputFormatters: [CardNumberFormatter()],
              decoration: _inputDecoration(
                label: 'CARD NUMBER',
                hint: '1234-1234-1234-1234',
                prefixIcon: _getPaymentIcon(),
                //suffixIcon: const Icon(Icons.check, color: Colors.green, size: 20),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter card number';
                }
                if (value.length < 19) {
                  return 'Card number must be 16 digits';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            
            // CVV & Expiration
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(4),
                    ],
                    decoration: _inputDecoration(label: 'CVV', hint: '199'),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Required';
                      }
                      if (value.length < 3) {
                        return 'Invalid CVV';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [ExpirationDateFormatter()],
                    decoration: _inputDecoration(label: 'EXPIRATION', hint: 'MM/YY'),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Required';
                      }
                      if (value.length < 5) {
                        return 'Invalid (MM/YY)';
                      }
                      final parts = value.split('/');
                      if (parts.length == 2) {
                        final month = int.tryParse(parts[0]);
                        if (month == null || month < 1 || month > 12) {
                          return 'Invalid month';
                        }
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // User Existing Address
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'User Existing Address',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                Switch(
                  value: _useExistingAddress,
                  onChanged: (value) {
                    setState(() {
                      _useExistingAddress = value;
                    });
                  },
                  activeThumbColor: Theme.of(context).scaffoldBackgroundColor,
                  activeTrackColor: Theme.of(context).primaryColor,
                  inactiveThumbColor: Theme.of(context).scaffoldBackgroundColor,
                  inactiveTrackColor: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
                  trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextFormField(
              enabled: !_useExistingAddress,
              decoration: _inputDecoration(
                label: 'ADDRESS', 
                hint: '13rd Apartment, Blair Avenue, California 961',
                prefixIcon: Icon(Iconsax.location_copy, size: 20, color: Colors.grey.shade600,),
              ),
              style: TextStyle(color: isDark ? Colors.grey.shade400 : Colors.grey.shade600, fontSize: 13),
              validator: (value) {
                if (!_useExistingAddress && (value == null || value.trim().isEmpty)) {
                  return 'Please enter your address';
                }
                return null;
              },
            ),
            const SizedBox(height: 40),
            
            // Confirm & Pay Button
            const SizedBox(height: 24),
          ],
        ),
      ),
      ),
    ),
    Container(
      padding: const EdgeInsets.only(
        left: 24,
        right: 24,
        top: 16,
        bottom: 32,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(
            color: Colors.grey.withValues(alpha: 0.1),
          ),
        ),
      ),
      child: PrimaryButton(
        text: 'Confirm & Pay',
        onPressed: () async {
          FocusScope.of(context).unfocus();
          if (_formKey.currentState!.validate()) {
            ref.read(loaderMessageProvider.notifier).updateMessage('PROCESSING PAYMENT...');
            if (context.mounted) {
              context.loaderOverlay.show();
            }
            
            await Future.delayed(const Duration(seconds: 3));
            
            if (context.mounted) {
              context.loaderOverlay.hide();
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                builder: (context) {
                  return Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Iconsax.tick_circle,
                          color: Colors.green,
                          size: 80,
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Payment Successful!',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Your order has been placed successfully.',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),
                        PrimaryButton(
                          text: 'Continue Shopping',
                          onPressed: () {
                            ref.read(cartProvider.notifier).clearCart();
                            Navigator.pop(context);
                            context.go('/home');
                          },
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  );
                },
              );
            }
          }
        },
      ),
    ),
  ],
),
    );
  }

  InputDecoration _inputDecoration({
    required String label,
    required String hint,
    Widget? suffixIcon,
    Widget? prefixIcon,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InputDecoration(
      labelText: label,
      labelStyle: Theme.of(
        context,
      ).textTheme.bodyLarge?.copyWith(color: const Color(0xFF6B7280)),
      hintText: hint,
      hintStyle: Theme.of(
        context,
      ).textTheme.bodyLarge?.copyWith(color: const Color(0xFF6B7280).withValues(alpha: 0.5)),
      filled: false,
      fillColor: Theme.of(context).colorScheme.surface,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: BorderSide(color: isDark ? Colors.grey.shade800 : Colors.grey.shade300, width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: BorderSide(color: Theme.of(context).colorScheme.onSurface, width: 1.5),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: BorderSide(color: isDark ? Colors.grey.shade800 : Colors.grey.shade300, width: 1.0),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: Colors.red, width: 1.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
      ),
      suffixIcon: suffixIcon,
      prefixIcon: prefixIcon,
      prefixIconConstraints: const BoxConstraints(minWidth: 48, minHeight: 48),
    );
  }

  Widget _getPaymentIcon() {
    String assetPath;
    switch (_selectedPaymentMethod) {
      case 0:
        assetPath = 'assets/icon/payment/pay_visa.svg';
        break;
      case 1:
        assetPath = 'assets/icon/payment/pay_mater.svg';
        break;
      case 2:
        assetPath = 'assets/icon/payment/pay_paypal.svg';
        break;
      case 3:
        assetPath = 'assets/icon/payment/pay_amex.svg';
        break;
      default:
        assetPath = 'assets/icon/payment/pay_visa.svg';
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: SvgPicture.asset(assetPath, width: 32, height: 24, fit: BoxFit.contain),
    );
  }

  Widget _buildPaymentMethods() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () => setState(() => _selectedPaymentMethod = 0),
          child: _paymentBox(
            selected: _selectedPaymentMethod == 0,
            child: SvgPicture.asset('assets/icon/payment/pay_visa.svg', width: 40),
          ),
        ),
        GestureDetector(
          onTap: () => setState(() => _selectedPaymentMethod = 1),
          child: _paymentBox(
            selected: _selectedPaymentMethod == 1,
            child: SvgPicture.asset('assets/icon/payment/pay_mater.svg', width: 40),
          ),
        ),
        GestureDetector(
          onTap: () => setState(() => _selectedPaymentMethod = 2),
          child: _paymentBox(
            selected: _selectedPaymentMethod == 2,
            child: SvgPicture.asset('assets/icon/payment/pay_paypal.svg', width: 40),
          ),
        ),
        GestureDetector(
          onTap: () => setState(() => _selectedPaymentMethod = 3),
          child: _paymentBox(
            selected: _selectedPaymentMethod == 3,
            child: SvgPicture.asset('assets/icon/payment/pay_amex.svg', width: 40),
          ),
        ),
      ],
    );
  }

  Widget _paymentBox({required Widget child, bool selected = false}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 44,
          width: 64,
          decoration: BoxDecoration(
            color: selected 
                ? (isDark ? Colors.grey.shade800 : Colors.white) 
                : (isDark ? Colors.grey.shade900 : Colors.grey.shade100),
            borderRadius: BorderRadius.circular(6),
            border: selected ? Border.all(
              color: isDark ? Colors.white : Colors.black, 
              width: 1.5
            ) : null,
          ),
          alignment: Alignment.center,
          child: child,
        ),
        if (selected)
          Positioned(
            right: -4,
            top: -4,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check,
                color: Colors.white,
                size: 10,
              ),
            ),
          ),
      ],
    );
  }
}

class CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String text = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (text.length > 16) text = text.substring(0, 16);
    
    StringBuffer buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 4 == 0 && nonZeroIndex != text.length) {
        buffer.write('-');
      }
    }
    
    var string = buffer.toString();
    return newValue.copyWith(
      text: string,
      selection: TextSelection.collapsed(offset: string.length),
    );
  }
}

class ExpirationDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String text = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (text.length > 4) text = text.substring(0, 4);
    
    StringBuffer buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      if (i == 1 && text.length > 2) {
        buffer.write('/');
      }
    }
    
    var string = buffer.toString();
    return newValue.copyWith(
      text: string,
      selection: TextSelection.collapsed(offset: string.length),
    );
  }
}
