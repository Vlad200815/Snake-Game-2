import 'package:flutter/material.dart';

class BlankField extends StatelessWidget {
  const BlankField({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Container(
          color: const Color.fromARGB(255, 35, 35, 35),
        ),
      ),
    );
  }
}
