import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  const CustomTextFormField({
    super.key,
    required this.text,
    required this.controller,
    required this.hintText,
    required this.validation,
    required this.ispasssword,
  });

  final String text;
  final TextEditingController controller;
  final String hintText;
  final String? Function(String?) validation;
  final bool ispasssword;

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.text,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(right: 18),
          child: TextFormField(
            obscureText: widget.ispasssword && _obscureText,
            validator: widget.validation,
            controller: widget.controller,
            decoration: InputDecoration(
              suffixIcon: widget.ispasssword
                  ? IconButton(
                      onPressed: () {
                        setState(() => _obscureText = !_obscureText);
                      },
                      icon: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                      ),
                    )
                  : const Icon(Icons.email),
              hintText: widget.hintText,
              hintStyle: const TextStyle(color: Colors.grey),
              fillColor: const Color(0xffE1E1E1),
              filled: true,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xffE1E1E1)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xffE1E1E1)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
