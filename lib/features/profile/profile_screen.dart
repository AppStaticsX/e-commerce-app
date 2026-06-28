import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sessionBox = Hive.box('session');
    final currentUserEmail = sessionBox.get('currentUser', defaultValue: 'demo@ministore.com');
    final usersBox = Hive.box('users');
    final userData = usersBox.get(currentUserEmail, defaultValue: {
      'firstName': 'DEMO',
      'lastName': 'ADMINISTRATOR',
    });

    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.light ? const Color(0xFFDCDCDC) : const Color(0xFF2C2C2C),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const SizedBox(height: 32),
            // Profile Name
            Text(
              '${userData['firstName']} ${userData['lastName']}'.toUpperCase(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 48),
            
            // Profile Picture
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1),
                  backgroundImage: const CachedNetworkImageProvider(
                    'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?ixlib=rb-4.0.3&auto=format&fit=crop&w=200&q=80',
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Theme.of(context).brightness == Brightness.light ? const Color(0xFFDCDCDC) : const Color(0xFF2C2C2C), // Match scaffold background
                      width: 3,
                    ),
                  ),
                  child: Icon(
                    Icons.edit,
                    size: 16,
                    color: Theme.of(context).colorScheme.surface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            
            // Unlock XP & Rewards Button
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.radio_button_checked, size: 14, color: Colors.greenAccent),
                  const SizedBox(width: 8),
                  Text(
                    currentUserEmail.toString().toUpperCase(),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 48),
            
            // Bottom White Container
            Expanded(
              child: Material(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    // Drag handle
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.only(top: 8, bottom: 100), // padding for bottom nav
                        children: [
                          _buildMenuItem(
                            context,
                            title: 'ORDERS',
                            subtitle: 'Your recent orders will show here'.toUpperCase()),
                          _buildMenuItem(context, title: 'REWARDS'),
                          _buildMenuItem(context, title: 'LOYALTY OVERVIEW'),
                          
                          const SizedBox(height: 24),
                          Container(
                            height: 10,
                            width: double.infinity,
                            color: Theme.of(context).brightness == Brightness.light ? const Color(0xFFF5F5F5) : const Color(0xFF1E1E1E),
                          ),
                          const SizedBox(height: 24),
                          
                          _buildMenuItem(context, title: 'SETTINGS'),
                          _buildMenuItem(context, title: 'SUPPORT'),
                          _buildMenuItem(context, title: 'REFER A FRIEND'),
                          const SizedBox(height: 12),
                          _buildMenuItem(
                            context,
                            title: 'LOGOUT',
                            textColor: Colors.red,
                            onTap: () async {
                              final sessionBox = Hive.box('session');
                              await sessionBox.delete('currentUser');
                              if (context.mounted) {
                                context.go('/login');
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required String title,
    String? trailingText,
    String? subtitle,
    Color? textColor,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap ?? () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                  color: textColor ?? Theme.of(context).colorScheme.onSurface,
                ),
              ),
              if (trailingText != null)
                Text(
                  trailingText,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
            ],
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ]
        ],
      ),
    ));
  }
}
