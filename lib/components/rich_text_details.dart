import 'package:flutter/material.dart';

class RichTextDetails extends StatelessWidget {
  const RichTextDetails({
    super.key,
    required this.title,
    required this.value,
  });
  final String title;
  final String value;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '$title ',
              style: TextStyle(
                fontSize: 16,
                  color: Colors.black.withOpacity(0.5),
                  fontWeight: FontWeight.w500),
            ),
            TextSpan(
              text: value,
              style: const TextStyle(color: Colors.black, fontSize: 18 , fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}
