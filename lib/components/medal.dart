import 'package:flutter/material.dart';

class Medal extends StatelessWidget {
  final String name;
  final int result;
  final String emoji;

  const Medal({
    super.key,
    required this.name,
    required this.result,
    required this.emoji,
  });

  @override
  Widget build(BuildContext context) {
    // return SizedBox(
    //   height: 36,
    //   child: ListTile(
    //     leading: Text(
    //       name,
    //       style: const TextStyle(
    //         color: Colors.white,
    //         fontSize: 15,
    //         fontWeight: FontWeight.bold,
    //       ),
    //     ),
    //     title: Text(
    //       "$result",
    //       style: const TextStyle(
    //         color: Colors.white,
    //         fontSize: 15,
    //         fontWeight: FontWeight.bold,
    //       ),
    //     ),
    //   ),
    //   //],
    //   //),
    // );

    return SizedBox(
      height: 36,
      child: Row(
        children: [
          Text(
            emoji,
            style: const TextStyle(color: Colors.white, fontSize: 24),
          ),
          const SizedBox(width: 4),
          Text(
            name,
            style: const TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(width: 8),
          Text(
            "$result",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
    );
  }
}
