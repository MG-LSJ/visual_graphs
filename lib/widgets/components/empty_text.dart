import 'package:flutter/material.dart';

class EmptyText extends StatelessWidget {
  const EmptyText({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
        child: Text("Empty", style: TextStyle(color: Colors.grey)));
  }
}
