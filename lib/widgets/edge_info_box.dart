import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:visual_graphs/components/edge_component.dart';

class EdgeInfoBox extends StatefulWidget {
  final EdgeComponent edgeComponent;
  const EdgeInfoBox({super.key, required this.edgeComponent});

  @override
  State<EdgeInfoBox> createState() => _EdgeInfoBoxState();
}

class _EdgeInfoBoxState extends State<EdgeInfoBox> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      title: Text(
          "Edge: Node ${widget.edgeComponent.edge.from.label} ${widget.edgeComponent.edge.isDirected ? "to" : "&"} Node ${widget.edgeComponent.edge.to.label}"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("ID: ${widget.edgeComponent.edge.id}"),
          TextField(
            decoration: const InputDecoration(
              labelText: "Weight",
            ),
            keyboardType: TextInputType.number,
            controller: TextEditingController(
                text: widget.edgeComponent.edge.weight.toString()),
            focusNode: FocusNode()..requestFocus(),
            onChanged: (value) {
              if (value.isEmpty) {
                widget.edgeComponent.edge.weight = 0;
              }
              try {
                widget.edgeComponent.edge.weight = int.parse(value);
              } catch (e) {
                return;
              }
            },
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9\-]')),
            ],
          ),
          CheckboxListTile(
            title: const Text("Directed"),
            value: widget.edgeComponent.edge.isDirected,
            onChanged: (value) => setState(() {
              widget.edgeComponent.gameRef.graph
                  .removeEdge(widget.edgeComponent.edge);
              widget.edgeComponent.edge.isDirected = value!;
              widget.edgeComponent.gameRef.graph
                  .addEdge(widget.edgeComponent.edge);
            }),
          ),
          if (widget.edgeComponent.edge.isDirected)
            ElevatedButton.icon(
              onPressed: () {
                widget.edgeComponent.gameRef.graph
                    .removeEdge(widget.edgeComponent.edge);

                // swap the vertices
                var temp = widget.edgeComponent.edge.from;
                widget.edgeComponent.edge.from = widget.edgeComponent.edge.to;
                widget.edgeComponent.edge.to = temp;

                widget.edgeComponent.gameRef.graph
                    .addEdge(widget.edgeComponent.edge);
                setState(() {});
              },
              label: const Text("Reverse"),
              icon: const Icon(Icons.swap_horiz_outlined),
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
