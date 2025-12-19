import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final TextInputType? keyboardType;
  final int? maxLines;
  final String? Function(String?)? validator;
  final String? labelText;
  final Widget? prefixIcon;
  final void Function(String)? onChanged;

  const TextFieldWidget({
    super.key,
    this.controller,
    this.hintText,
    this.keyboardType,
    this.maxLines,
    this.validator,
    this.labelText,
    this.prefixIcon,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        border: const OutlineInputBorder(),
        prefixIcon: prefixIcon,
      ),
      validator: validator,
    );
  }
}
