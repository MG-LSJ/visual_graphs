import 'package:flutter/material.dart';

class WhiteBorder extends StatelessWidget {
  final Widget child;
  const WhiteBorder({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(5),
      ),
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
      child: child,
    );
  }
}
