import 'package:flutter/material.dart';

class CustomField extends StatelessWidget {
  const CustomField({
    super.key,
    required this.hintText,
    required this.controller,
    this.isObsecureText = false,
    this.isReadOnly = false,
    this.onTap,
  });

  final bool isReadOnly;
  final String hintText;
  final TextEditingController? controller;
  final bool isObsecureText;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: isReadOnly,
      controller: controller,
      onTap: onTap,
      decoration: InputDecoration(
        hintText: hintText,
      ),
      validator: (v) {
        if (v!.isEmpty) {
          return '$hintText is missing!';
        }
        return null;
      },
      obscureText: isObsecureText,
    );
  }
}
