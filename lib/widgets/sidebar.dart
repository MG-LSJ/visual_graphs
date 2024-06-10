import 'package:flutter/material.dart';
import 'package:visual_graphs/widgets/bft_widget.dart';

class Sidebar extends StatefulWidget {
  const Sidebar({super.key});

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  bool isMinimized = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.onSurface,
      child: Stack(
        // mainAxisSize: MainAxisSize.min,
        // mainAxisAlignment: MainAxisAlignment.start,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Offstage(
            offstage: isMinimized,
            child: Container(
              padding: const EdgeInsets.all(20),
              width: 400,
              child: const BFTWidget(),
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
    );
  }
}
