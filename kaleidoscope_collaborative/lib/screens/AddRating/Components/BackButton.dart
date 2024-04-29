import 'package:flutter/material.dart';

class BackButton2 extends StatelessWidget {
  const BackButton2({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text(
          'Back to business page',
          style: TextStyle(
            decoration: TextDecoration.underline,
            color: Color(0xFF6750A4),
          ),
        ),
      ),
    );
  }
}
