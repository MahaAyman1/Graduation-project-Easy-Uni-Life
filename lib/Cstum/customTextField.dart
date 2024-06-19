/*import 'package:appwithapi/Cstum/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/widgets/framework.dart';

class CustomTextField extends StatelessWidget {
  CustomTextField({
    Key? key,
    required this.hint,
    this.maxLines = 1,
    this.obscureText = false,
    this.controller,
    this.validator, // Add validator parameter
    this.onSaved,
    this.onChanged,
    this.readOnly = false,
    String? errorText, required String label,
  }) : super(key: key);

  final String hint;
  final int maxLines;
  final bool obscureText;
  final TextEditingController? controller;
  final String? Function(String?)? validator; // Validator parameter
  final void Function(String?)? onSaved;
  final Function(String)? onChanged;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText,
      onChanged: onChanged,
      controller: controller,
      onSaved: onSaved,
      validator: (value) {
        // Use the provided validator if available, otherwise use default "required field" validator
        if (validator != null) {
          return validator!(value);
        } else {
          if (value?.isEmpty ?? true) {
            return 'Field is required';
          } else {
            return null;
          }
        }
      },
      readOnly: readOnly,
      cursorColor: kPrimaryColor,
      maxLines: maxLines,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: hint,
        border: buildBorder(),
        enabledBorder: buildBorder(kPrimaryColor),
        focusedBorder: buildBorder(kPrimaryColor),
      ),
    );
  }

  OutlineInputBorder buildBorder([color]) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide(color: color ?? Colors.white),
    );
  }
}
*/

import 'package:appwithapi/Cstum/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/widgets/framework.dart';

class CustomTextField extends StatelessWidget {
  final String? label;
  final String hint;
  final int maxLines;
  final bool obscureText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final Function(String)? onChanged;
  final Future<Null> Function()? onTap;
  final TextInputType? keyboardType;

  final bool? readOnly;
  CustomTextField({
    Key? key,
    this.label,
    required this.hint,
    this.maxLines = 1,
    this.obscureText = false,
    this.controller,
    this.validator,
    this.onSaved,
    this.onChanged,
    this.onTap,
    this.readOnly,
    this.keyboardType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Text(
            label!,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        if (label != null) SizedBox(height: 8),
        TextFormField(
          obscureText: obscureText,
          onChanged: onChanged,
          controller: controller,
          onSaved: onSaved,
          validator: (value) {
            if (validator != null) {
              return validator!(value);
            } else {
              if (value?.isEmpty ?? true) {
                return 'Field is required';
              } else {
                return null;
              }
            }
          },
          cursorColor: kPrimaryColor,
          maxLines: maxLines,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: hint,
            border: buildBorder(),
            enabledBorder: buildBorder(kPrimaryColor),
            focusedBorder: buildBorder(kPrimaryColor),
          ),
        ),
      ],
    );
  }

  OutlineInputBorder buildBorder([Color? color]) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide(color: color ?? Colors.white),
    );
  }
}
