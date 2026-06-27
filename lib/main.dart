import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/custom_loader_overlay.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive for local storage
  await Hive.initFlutter();
  
  // We'll open boxes later in providers, but opening a main box here is good
  await Hive.openBox('settings');
  await Hive.openBox('cart');
  await Hive.openBox('favorites');
  
  final usersBox = await Hive.openBox('users');
  if (usersBox.isEmpty) {
    await usersBox.put('demo@ministore.com', {
      'firstName': 'Demo',
      'lastName': 'Administrator',
      'dob': '1981-01-01',
      'password': 'Demo@admin#1',
    });
  }
  
  await Hive.openBox('session');

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // We could read theme from a provider, but we'll stick to light for now
    // as per the sleek UI design requested.
    return MaterialApp.router(
      title: 'Mini Store',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system, // Or read from provider if we implement dark mode toggle
      routerConfig: AppRouter.router,
      builder: (context, child) {
        return CustomLoaderOverlay(
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
