import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/custom_loader_overlay.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration(
    String hint, {
    Widget? suffixIcon,
    Widget? prefixIcon,
  }) {
    return InputDecoration(
      labelText: hint,
      labelStyle: Theme.of(
        context,
      ).textTheme.bodyLarge?.copyWith(color: const Color(0xFF6B7280)),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: BorderSide(color: Colors.grey.shade300, width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: Colors.black, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
      ),
      suffixIcon: suffixIcon,
      prefixIcon: prefixIcon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 32.0,
                vertical: 32.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 40),
                  // Logo Placeholder
                  Center(
                    child: Icon(
                      Iconsax.shopping_bag_copy,
                      size: 80,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Title
                  Text(
                    'MINI-STORE LOGIN',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Subtitle
                  Text(
                    'Shop your styles, save top picks to your wishlist,\ntrack those orders & train with us.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade700,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Email
                  TextFormField(
                    controller: _emailController,
                    decoration: _inputDecoration(
                      'Email address'.toUpperCase(),
                      prefixIcon: Icon(
                        Iconsax.sms_copy,
                        color: Colors.grey.shade600,
                        size: 20,
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    style: Theme.of(context).textTheme.bodyLarge,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Password
                  TextFormField(
                    controller: _passwordController,
                    decoration: _inputDecoration(
                      'Password'.toUpperCase(),
                      prefixIcon: Icon(
                        Iconsax.lock_copy,
                        color: Colors.grey.shade600,
                        size: 20,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? LucideIcons.eyeOff
                              : LucideIcons.eye,
                          color: Colors.grey.shade600,
                          size: 20,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                    obscureText: !_isPasswordVisible,
                    style: Theme.of(context).textTheme.bodyLarge,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // Forgot Password
                  Center(
                    child: GestureDetector(
                      onTap: () {},
                      child: Text(
                        'Forgot password?',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Log in Button
                  Consumer(
                    builder: (context, ref, child) {
                      return PrimaryButton(
                        text: 'LOG IN',
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            ref
                                .read(loaderMessageProvider.notifier)
                                .updateMessage('LOGGING...');
                            context.loaderOverlay.show();
                            await Future.delayed(const Duration(seconds: 3));
                            if (context.mounted) {
                              context.loaderOverlay.hide();
                              context.go('/home');
                            }
                          }
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 64),
                  // Social Login Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Google Button
                      OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(16),
                          side: BorderSide(color: Colors.grey.shade300),
                        ),
                        child: SvgPicture.asset(
                          'assets/icon/auth/auth_google.svg',
                          width: 30,
                          height: 30,
                        ),
                      ),
                      const SizedBox(width: 24),
                      // Apple Button
                      OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(16),
                          side: BorderSide(color: Colors.grey.shade300),
                        ),
                        child: SvgPicture.asset(
                          'assets/icon/auth/auth_apple.svg',
                          width: 30,
                          height: 30,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Sign up
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(color: Colors.black87),
                      ),
                      GestureDetector(
                        onTap: () {
                          context.push('/signup');
                        },
                        child: Text(
                          'Sign up',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                decoration: TextDecoration.underline,
                              ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
