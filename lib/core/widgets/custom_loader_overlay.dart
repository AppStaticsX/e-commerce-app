import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoaderMessageNotifier extends Notifier<String> {
  @override
  String build() => 'LOADING...';

  void updateMessage(String newMessage) {
    state = newMessage;
  }
}

final loaderMessageProvider = NotifierProvider<LoaderMessageNotifier, String>(() {
  return LoaderMessageNotifier();
});

class CustomLoaderOverlay extends ConsumerWidget {
  final Widget child;

  const CustomLoaderOverlay({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final message = ref.watch(loaderMessageProvider);

    return LoaderOverlay(
      overlayColor: Colors.transparent,
      overlayWidgetBuilder: (progress) {
        return CustomLoaderWidget(message: message);
      },
      child: child,
    );
  }
}

class CustomLoaderWidget extends StatelessWidget {
  final String message;

  const CustomLoaderWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: 4.5,
        sigmaY: 4.5,
      ),
      child: Center(
        child: Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 44,
                    height: 44,
                    child: CircularProgressIndicator(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      strokeCap: StrokeCap.round,
                      strokeWidth: 5,
                    ),
                  ),
                  Icon(
                    Iconsax.shopping_bag_copy, 
                    color: Theme.of(context).scaffoldBackgroundColor, 
                    size: 20,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  fontSize: 10,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
