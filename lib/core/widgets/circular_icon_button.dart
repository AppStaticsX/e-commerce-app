import 'package:flutter/material.dart';

class CircularIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const CircularIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
        ),
        child: Icon(icon, size: 20, color: Theme.of(context).textTheme.bodyLarge?.color),
      ),
    );
  }
}
