import 'package:flutter/material.dart';
import 'package:social_media/core/extentions/context_extensions.dart';

class ValidatedTextField extends StatelessWidget {
  const ValidatedTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    required this.validator,
  });

  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final String? Function(String?) validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      textInputAction: TextInputAction.next,
      validator: validator,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        hintText: hintText,
        hintStyle: TextStyle(color: context.colorScheme.primary),
        filled: true,
        fillColor: context.colorScheme.secondary,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: context.colorScheme.tertiary),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: context.colorScheme.primary),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
