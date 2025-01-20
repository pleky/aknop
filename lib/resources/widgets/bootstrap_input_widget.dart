import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class BootstrapStyleTextField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FormBuilderTextField(
          name: 'bootstrap_textfield',
          decoration: InputDecoration(
            labelText: 'Bootstrap Styled Input',
            labelStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            hintText: 'Enter text here',
            hintStyle: TextStyle(
              color: Colors.grey[500],
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.0), // Rounded corners
              borderSide: BorderSide(
                color: Colors.grey, // Default border color
                width: 1.0,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.0),
              borderSide: BorderSide(
                color: Colors.grey,
                width: 1.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.0),
              borderSide: BorderSide(
                color: Colors.blue,
                width: 2.0,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.0),
              borderSide: BorderSide(
                color: Colors.red,
                width: 2.0,
              ),
            ),
            filled: true, // Mimic the filled effect of Bootstrap inputs
            fillColor: Colors.white,
            suffixIcon: Icon(Icons.edit, color: Colors.grey),
          ),
          keyboardType: TextInputType.text,
        ),
      ],
    );
  }
}
