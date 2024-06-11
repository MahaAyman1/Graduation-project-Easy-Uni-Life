import 'package:flutter/material.dart';

class ResizableTextField extends StatefulWidget {
  @override
  _ResizableTextFieldState createState() => _ResizableTextFieldState();
}

class _ResizableTextFieldState extends State<ResizableTextField> {
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: TextField(
        controller: _controller,
        onChanged: (text) {
          setState(() {});
        },
        maxLines: null, // Allows for multiline input
        decoration: InputDecoration.collapsed(hintText: "Enter text here"),
      ),
    );
  }
}
