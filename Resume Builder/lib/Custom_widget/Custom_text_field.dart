import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final IconData? prefixIcon;
  final int maxLine;
  final TextInputType keyboardTypes;
  final void Function(String?)? onSaved;
  final String? Function(String?)? validator;
  final bool obscureText;

  const CustomTextField({
    super.key,
    required this.hintText,
    this.onSaved,
    this.validator,
    this.prefixIcon,
    this.maxLine = 1,
    this.obscureText = false,
    this.keyboardTypes=TextInputType.text,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        maxLines: widget.maxLine,
        onSaved: widget.onSaved,
        validator: widget.validator,
        obscureText: widget.obscureText,
        cursorColor: const Color(0xFF003366), // cursor ka  color mean |
        keyboardType: widget.keyboardTypes,
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFF003366).withOpacity(0.1),
          hintText: widget.hintText,
          hintStyle: TextStyle(
            color: const Color(0xFF003366).withOpacity(0.6),
            fontSize: 16,
          ),

          prefixIcon: widget.prefixIcon != null
              ? Icon(widget.prefixIcon, color: const Color(0xFF003366))
              : null,
          contentPadding:  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
