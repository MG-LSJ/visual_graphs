import 'package:flutter/material.dart';
import 'package:visual_graphs/graph_editor/globals.dart';
import 'package:visual_graphs/widgets/bft_widget.dart';
import 'package:visual_graphs/widgets/dft_widget.dart';
import 'package:visual_graphs/widgets/kruskal_widget.dart';

enum Algorithms {
  bft,
  dft,
  kruskal,
}

class Sidebar extends StatefulWidget {
  const Sidebar({super.key});

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  bool isMinimized = false;
  Algorithms currentAlgorithm = Algorithms.bft;
  final GlobalKey childKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark(useMaterial3: true),
      child: Container(
        color: Theme.of(context).colorScheme.onSurface,
        child: Stack(
          children: [
            Offstage(
              offstage: isMinimized,
              child: Container(
                padding: const EdgeInsets.all(20),
                width: 400,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 50,
                      child: DropdownMenu<Algorithms>(
                        initialSelection: Algorithms.bft,
                        onSelected: (value) {
                          setState(() {
                            currentAlgorithm = value!;
                          });
                        },
                        textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                        width: 360,
                        dropdownMenuEntries: const [
                          DropdownMenuEntry<Algorithms>(
                            value: Algorithms.bft,
                            label: "Breadth First Traversal",
                          ),
                          DropdownMenuEntry<Algorithms>(
                            value: Algorithms.dft,
                            label: "Depth First Traversal",
                          ),
                          DropdownMenuEntry(
                              value: Algorithms.kruskal,
                              label: "Kruskal's Algorithm")
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height - 110,
                      ),
                      child: ListenableBuilder(
                        listenable: Globals.game.graph.verticesNotifier,
                        builder: (context, child) {
                          childKey.currentState?.build(context);
                          return child!;
                        },
                        child: child,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: double.infinity,
              width: 50,
              child: MaterialButton(
                onPressed: () => setState(() {
                  isMinimized = !isMinimized;
                }),
                colorBrightness: Brightness.dark,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                visualDensity: VisualDensity.compact,
                child: Icon(
                  isMinimized ? Icons.arrow_back_ios : Icons.arrow_forward_ios,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  StatefulWidget get child {
    switch (currentAlgorithm) {
      case Algorithms.bft:
        return BFTWidget(key: childKey);
      case Algorithms.dft:
        return DFTWidget(key: childKey);
      case Algorithms.kruskal:
        return KruskalWidget(key: childKey);
    }
  }
}
