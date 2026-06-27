import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/widgets/primary_button.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _receiveEmails = false;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dobController.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
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

  InputDecoration _inputDecoration(String label, {Widget? suffixIcon}) {
    return InputDecoration(
      labelText: label,
      labelStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(color: const Color(0xFF6B7280)),
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
      suffixIcon: suffixIcon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 24),
                // Logo
                Center(
                  child: Icon(Iconsax.shopping_bag_copy, size: 80, color: Colors.black),
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
                TextField(
                  controller: _firstNameController,
                  decoration: _inputDecoration('First Name'),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 16),

                // Last Name
                TextField(
                  controller: _lastNameController,
                  decoration: _inputDecoration('Last Name'),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 16),

                // Date Of Birth
                TextField(
                  controller: _dobController,
                  decoration: _inputDecoration('Date Of Birth'),
                  style: Theme.of(context).textTheme.bodyLarge,
                  readOnly: true,
                  onTap: () => _selectDate(context),
                ),
                const SizedBox(height: 16),

                // Email
                TextField(
                  controller: _emailController,
                  decoration: _inputDecoration('Email address*'),
                  keyboardType: TextInputType.emailAddress,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 16),

                // Password
                TextField(
                  controller: _passwordController,
                  decoration: _inputDecoration(
                    'Password*',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible ? LucideIcons.eyeOff : LucideIcons.eye,
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
                ),
                const SizedBox(height: 24),

                // Checkbox
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: Checkbox(
                        value: _receiveEmails,
                        onChanged: (value) {
                          setState(() {
                            _receiveEmails = value ?? false;
                          });
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        side: BorderSide(color: Colors.grey.shade400, width: 1.5),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.black87,
                            height: 1.4,
                          ),
                          children: const [
                            TextSpan(text: 'Tick here to receive emails about our products, apps, sales, exclusive content and more. See our '),
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
                const SizedBox(height: 32),

                // Create Account Button
                PrimaryButton(
                  text: 'CREATE ACCOUNT',
                  onPressed: () {
                    // Navigate to home or wherever appropriate
                  },
                ),
                const SizedBox(height: 24),

                // Log in link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account? ",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.black87,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        context.pop(); // Go back to login screen
                      },
                      child: Text(
                        'Log in',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
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
    );
  }
}
