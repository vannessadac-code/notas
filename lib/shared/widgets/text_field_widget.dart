import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final TextInputType? keyboardType;
  final int? maxLines;
  final String? Function(String?)? validator;

  const TextFieldWidget({
    super.key,
    this.controller,
    this.hintText,
    this.keyboardType,
    this.maxLines,
    this.validator
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: hintText,
        border: const OutlineInputBorder(),
      ),
      validator: validator,
    );
  }
}
