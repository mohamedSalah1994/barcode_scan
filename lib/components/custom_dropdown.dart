import 'package:flutter/material.dart';

class CustomDropdownField extends StatelessWidget {
  final String labelText;
  final String? value;
  final Map<int, String> items;
   final String? validateValue;
  final ValueChanged<String?> onChanged;

  const CustomDropdownField({
    Key? key,
    required this.labelText,
    required this.value,
    required this.items,
    
    required this.onChanged, this.validateValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: FormField<String>(
        validator: (value) {
                    if (value == null || value.isEmpty) {
                      return validateValue;
                    }
                    return null;
                  },
        builder: (FormFieldState<String> state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<String>(
                value: value,
                decoration: InputDecoration(
                  labelText: labelText,
                  border: const OutlineInputBorder(),
                  errorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 2.0),
                  ),
                  focusedErrorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 2.0),
                  ),
                ),
                onChanged: onChanged,
                items: items.entries.map((entry) {
                  return DropdownMenuItem<String>(
                    value: entry.value,
                    child: Text(entry.value),
                  );
                }).toList(),
              ),
              if (state.hasError)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    state.errorText ?? '',
                    style: TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
