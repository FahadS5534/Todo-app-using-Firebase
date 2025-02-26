import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final String label;

  final TextEditingController controller;

  const MyTextField({
    super.key,
    required this.hintText,
    required this.label,
    required this.obscureText,
    required this.controller,
  });
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.tertiary),
            borderRadius: const BorderRadius.all(Radius.circular(12))),
        focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.primary),
            borderRadius: const BorderRadius.all(Radius.circular(12))),
        labelText: label,
        hintText: hintText,
        hintStyle:
            TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color),
        fillColor: Colors.white,
        filled: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 28.0, horizontal: 12.0),
      ),
      obscureText: obscureText,
      controller: controller,
    );
  }
}
