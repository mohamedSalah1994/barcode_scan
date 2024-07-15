import 'package:flutter/material.dart';

class HomeTextField extends StatelessWidget {
  const HomeTextField({
    Key? key,
    required this.text,
    this.onChanged,
    this.required = false, this.onSaved,
  }) : super(key: key);

  final String text;
  final void Function(String)? onChanged;
  final void Function(String?)? onSaved;
  
  final bool required;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      child: TextFormField(
         validator: (value) {
        if (value == null || value.isEmpty) {
          return "This field is required";
        }
        return null;
      },
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: required ? Colors.red : Colors.white, 
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: required ? Colors.red : Colors.grey.shade400,
            ),
          ),
            errorBorder: customErrorBorder(),
          focusedErrorBorder: customErrorBorder(),
          fillColor: Colors.grey.shade200,
          filled: true,
          hintText: text,
          hintStyle: const TextStyle(
            color: Colors.grey,
          ),
        ),
        onChanged: onChanged,
        onSaved: onSaved,
        
      ),
    );
  }

  OutlineInputBorder customErrorBorder() {
    return const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.red, // Error border color
          ),
        );
  }
}
