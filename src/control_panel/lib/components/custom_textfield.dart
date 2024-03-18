import 'package:flutter/material.dart';

/// Defines a custom textfield to enter an id or a password
class CustomTextField extends StatelessWidget {
  final dynamic controller;
  final String labelText;
  final bool obscureText;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return SizedBox(
      width: width * 0.3,
      height: height * 0.1,
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF1331F5)),
          ),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
          fillColor: const Color.fromARGB(255, 255, 255, 255),
          filled: true,
          labelText: labelText,
        ),
      ),
    );
  }
}

