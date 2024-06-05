import 'package:flutter/material.dart';

class GenderDropdownButton extends StatelessWidget {
  final List<String> items;
  final String? selectedValue;
  final ValueChanged<String?> onChanged;
  final String hint;

  const GenderDropdownButton({
    required this.items,
    required this.selectedValue,
    required this.onChanged,
    required this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      menuMaxHeight: 100,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white, // Change the fill color to white
        contentPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
              20), // Use the same border radius as CustomTextField
          borderSide: BorderSide(color: Colors.black),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
              20), // Use the same border radius as CustomTextField
          borderSide: BorderSide(color: Colors.black),
        ),
      ),
      hint: Text(hint),
      style: TextStyle(fontSize: 14, color: Colors.black),
      value: selectedValue,
      items: items
          .map((item) => DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: const TextStyle(fontSize: 14),
                ),
              ))
          .toList(),
      validator: (value) {
        if (value == null) {
          return 'Please select gender.';
        }
        return null;
      },
      onChanged: onChanged,
    );
  }
}
