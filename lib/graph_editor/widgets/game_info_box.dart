import 'package:flutter/material.dart';

const double _labelSize = 16;

class GameInfoBox extends StatelessWidget {
  const GameInfoBox({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "Instructions",
      ),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
            TextSpan(
              children: [
                WidgetSpan(child: Icon(Icons.mouse, size: _labelSize)),
                TextSpan(text: " Defualt Mode"),
              ],
            ),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: _labelSize,
            ),
            textAlign: TextAlign.start,
          ),
          Text(
            "Darg to pan camera / move vertex",
          ),
          Text(
            "Hold Click or Long Tap on Vertex or Edge to edit it.",
          ),
          Text(""),
          Text.rich(
            TextSpan(
              children: [
                WidgetSpan(child: Icon(Icons.add, size: _labelSize)),
                TextSpan(text: " Add Vertex"),
              ],
            ),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: _labelSize,
            ),
          ),
          Text(
            "Click on empty area to add a vertx.",
          ),
          Text(""),
          Text.rich(
            TextSpan(
              children: [
                WidgetSpan(child: Icon(Icons.linear_scale, size: _labelSize)),
                TextSpan(text: " Add Edge"),
              ],
            ),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: _labelSize,
            ),
          ),
          Text(
            "Click on Vertex to set source point.",
          ),
          Text(
            "Click on another Vertex to set destination point",
          ),
          Text("Or on the same to add a self edge."),
          Text(""),
          Text.rich(
            TextSpan(
              children: [
                WidgetSpan(child: Icon(Icons.delete, size: _labelSize)),
                TextSpan(text: " Delete Component"),
              ],
            ),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: _labelSize,
            ),
          ),
          Text(
            "Click on a Vertex or Edge to delete it.",
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Close"),
        ),
      ],
    );
  }
}
