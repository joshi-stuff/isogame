library items;

import 'dart:html' hide Rectangle, Point;

import 'package:isogame/enums.dart';
import 'package:isogame/board.dart';
import 'package:isogame/graphics.dart';


////////////////////////////////////////////////////////////////////////////////////////////////////
// TREE
////////////////////////////////////////////////////////////////////////////////////////////////////
class TreeType extends Enum {
  static final ELM = new TileType("ELM");
  static final ORANGE = new TileType("ORANGE");
  static final PINE = new TileType("PINE");
  static final FIR = new TileType("FIR");
  static final PALM = new TileType("PALM");

  static Iterable<TreeType> get values => Enum.values(TreeType);

  TreeType(String name) : super(TreeType, name);
}

class Tree extends Item {
  static final TILE_SIZE = new Size(1, 1);
  static const TILE_HEIGHT = 2;

  final TreeType type;

  Tree([TreeType treeType = null])
      : super(TILE_SIZE, TILE_HEIGHT),
        type = (treeType == null) ? TreeType.ELM : treeType;

  Element createImage() => new ImageElement()..src = "rc/Tree/${type.name}.png";

  void initialize() {
    super.initialize();
    level = 2;
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
// CASTLE
////////////////////////////////////////////////////////////////////////////////////////////////////
class Castle extends Item {
  static final TILE_SIZE = new Size(3, 3);
  static const TILE_HEIGHT = 3;

  Castle() : super(TILE_SIZE, TILE_HEIGHT);

  Element createImage() => new ImageElement()..src = "rc/Castle/DEFAULT.png";

  void initialize() {
    super.initialize();

    level = 2;
  }
}
