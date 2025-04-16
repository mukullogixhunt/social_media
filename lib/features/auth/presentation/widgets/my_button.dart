import 'package:flutter/material.dart';
import 'package:social_media/core/extentions/context_extensions.dart';

class MyButton extends StatelessWidget {
  const MyButton({super.key, this.onTap, required this.text});

  final void Function()? onTap;
  final String text;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: context.colorScheme.tertiary,
          foregroundColor: context.colorScheme.inversePrimary,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onTap,
        child: Text(
          text,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
