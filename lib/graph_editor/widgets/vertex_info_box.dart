import 'package:flutter/material.dart';
import 'package:visual_graphs/graph_editor/components/vertex_component.dart';

class VertexInfoBox extends StatefulWidget {
  final VertexComponent vertexComponent;
  const VertexInfoBox({super.key, required this.vertexComponent});

  @override
  State<VertexInfoBox> createState() => _VertexInfoBoxState();
}

class _VertexInfoBoxState extends State<VertexInfoBox> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      title: Text("Node ${widget.vertexComponent.vertex.label}"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("ID: ${widget.vertexComponent.vertex.id}"),
          TextField(
            decoration: const InputDecoration(
              labelText: "Label",
            ),
            controller: TextEditingController(
                text: widget.vertexComponent.vertex.label),
            focusNode: FocusNode()..requestFocus(),
            onChanged: (value) {
              widget.vertexComponent.vertex.label = value;
            },
          ),
          const SizedBox(height: 10),
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
