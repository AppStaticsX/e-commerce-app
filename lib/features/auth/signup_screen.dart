import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/custom_loader_overlay.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _checkedPrivacy = false;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dobController.text =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _dobController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration(
    String label, {
    Widget? suffixIcon,
    Widget? prefixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: Theme.of(
        context,
      ).textTheme.bodyLarge?.copyWith(color: const Color(0xFF6B7280)),
      filled: false,
      fillColor: Theme.of(context).colorScheme.surface,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: BorderSide(color: Colors.grey.shade300, width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: BorderSide(color: Theme.of(context).colorScheme.onSurface, width: 1.5),
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                  const SizedBox(height: 24),
                  // Logo
                  Center(
                    child: Icon(
                      Iconsax.shopping_bag_copy,
                      size: 80,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Title
                  Text(
                    'MINI-STORE SIGNUP',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Subtitle
                  Text(
                    'One account, across all apps, just to make things\na little easier.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade700,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // First Name
                  TextFormField(
                    controller: _firstNameController,
                    decoration: _inputDecoration(
                      'First Name'.toUpperCase(),
                      prefixIcon: Icon(
                        Iconsax.user_copy,
                        color: Colors.grey.shade600,
                        size: 20,
                      ),
                    ),
                    style: Theme.of(context).textTheme.bodyLarge,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'First name is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Last Name
                  TextFormField(
                    controller: _lastNameController,
                    decoration: _inputDecoration(
                      'Last Name'.toUpperCase(),
                      prefixIcon: Icon(
                        Iconsax.user_copy,
                        color: Colors.grey.shade600,
                        size: 20,
                      ),
                    ),
                    style: Theme.of(context).textTheme.bodyLarge,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Last name is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Date Of Birth
                  TextFormField(
                    controller: _dobController,
                    decoration: _inputDecoration(
                      'Date Of Birth'.toUpperCase(),
                      prefixIcon: Icon(
                        Iconsax.calendar_1_copy,
                        color: Colors.grey.shade600,
                        size: 20,
                      ),
                    ),
                    style: Theme.of(context).textTheme.bodyLarge,
                    readOnly: true,
                    onTap: () => _selectDate(context),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Date of Birth is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

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
                        return 'Email is required';
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Enter a valid email';
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
                        return 'Password is required';
                      }
                      if (value.length < 6) {
                        return 'Must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // Checkbox
                  FormField<bool>(
                    validator: (value) {
                      if (!_checkedPrivacy) {
                        return 'You must accept the Privacy Policy to continue';
                      }
                      return null;
                    },
                    builder: (state) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 24,
                                height: 24,
                                child: Checkbox(
                                  value: _checkedPrivacy,
                                  onChanged: (value) {
                                    setState(() {
                                      _checkedPrivacy = value ?? false;
                                      state.didChange(value);
                                    });
                                  },
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  side: BorderSide(
                                    color: state.hasError
                                        ? Colors.redAccent
                                        : Colors.grey.shade400,
                                    width: 1.5,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: RichText(
                                    text: TextSpan(
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.87),
                                            height: 1.4,
                                          ),
                                    children: const [
                                      TextSpan(
                                        text:
                                            'Tick here to receive emails about our products, apps, sales, exclusive content and more. See our ',
                                      ),
                                      TextSpan(
                                        text: 'Privacy Policy.',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (state.hasError)
                            Padding(
                              padding: const EdgeInsets.only(top: 8, left: 36),
                              child: Text(
                                state.errorText!,
                                style: const TextStyle(
                                  color: Colors.redAccent,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 32),

                  // Create Account Button
                  Consumer(
                    builder: (context, ref, child) {
                      return PrimaryButton(
                        text: 'CREATE ACCOUNT',
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            ref
                                .read(loaderMessageProvider.notifier)
                                .updateMessage('CREATING\nACCOUNT...');
                            context.loaderOverlay.show();
                            
                            // Save user details
                            final usersBox = Hive.box('users');
                            await usersBox.put(_emailController.text, {
                              'firstName': _firstNameController.text,
                              'lastName': _lastNameController.text,
                              'dob': _dobController.text,
                              'password': _passwordController.text,
                            });
                            
                            final sessionBox = Hive.box('session');
                            await sessionBox.put('currentUser', _emailController.text);
                            
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
                  const SizedBox(height: 24),

                  // Log in link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account? ",
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.87)),
                      ),
                      GestureDetector(
                        onTap: () {
                          context.pop(); // Go back to login screen
                        },
                        child: Text(
                          'Log in',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onSurface,
                                decoration: TextDecoration.underline,
                              ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
