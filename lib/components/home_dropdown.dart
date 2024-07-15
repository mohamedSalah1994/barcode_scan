import 'package:flutter/material.dart';

class HomeDropdown extends StatelessWidget {
  const HomeDropdown({
    Key? key,
    required this.text,
    required this.value,
    required this.items,
    required this.onChanged,
  }) : super(key: key);

  final String text;
  final String value;
  final List<DropdownMenuItem<String>> items;
  final void Function(String?) onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: value,
          icon: const Icon(Icons.arrow_drop_down),
          iconSize: 24,
          elevation: 16,
          style: const TextStyle(color: Colors.black),
          onChanged: onChanged,
          items: items,
        ),
      ),
    );
  }
}
