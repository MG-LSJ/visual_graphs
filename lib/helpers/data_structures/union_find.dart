import 'dart:ui';

import 'package:visual_graphs/helpers/data_structures/pair.dart';
import 'package:visual_graphs/helpers/material_color_generator.dart';

abstract class UnionFind<K, P> {
  Map<K, P> parent = {};

  void union(K a, K b);

  P find(K a);

  void clear() {
    parent.clear();
  }
}

class ColoredUnionFind<T> extends UnionFind<T, Pair<T, Color?>> {
  final MaterialColorGenerator materialColorGenerator =
      MaterialColorGenerator();

  @override
  union(T a, T b) {
    var aParent = find(a);
    var bParent = find(b);

    if (aParent.first == bParent.first) {
      return;
    }

    switch ((aParent.second != null, bParent.second != null)) {
      case (true, true):
        parent[aParent.first] = bParent;
        break;
      case (true, false):
        parent[bParent.first] = aParent;
        break;
      case (false, true):
        parent[aParent.first] = bParent;
        break;
      case (false, false):
        var color = materialColorGenerator.next();
        parent[aParent.first] = Pair(bParent.first, color);
        parent[bParent.first] = Pair(bParent.first, color);
        break;
    }
  }

  @override
  Pair<T, Color?> find(T a) {
    if (parent[a] == null) {
      parent[a] = Pair(a, null);
      return parent[a]!;
    } else {
      if (parent[a]!.first == a) {
        return parent[a]!;
      } else {
        return parent[a] = find(parent[a]!.first);
      }
    }
  }
}
