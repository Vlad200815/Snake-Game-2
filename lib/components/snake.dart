import 'package:flutter/material.dart';

class Snake extends StatelessWidget {
  const Snake({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Container(
          color: Colors.green,
        ),
      ),
    );
  }
}
