import 'package:flutter/material.dart';

class Food extends StatelessWidget {
  const Food({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Container(
          color: Colors.red[700],
        ),
      ),
    );
  }
}
