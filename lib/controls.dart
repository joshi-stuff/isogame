library controls;

import 'dart:async';
import 'dart:html' hide Rectangle, Point;

import 'package:isogame/graphics.dart';


////////////////////////////////////////////////////////////////////////////////////////////////////
// DEBUG PANEL
////////////////////////////////////////////////////////////////////////////////////////////////////
class DebugPanel extends Widget with Attach {
  final _showItemImageBorders = new CheckboxInputElement();
  final _showItemImageBordersLabel = new SpanElement()..appendText("Show item borders");

  @override
  Element createElement() => new DivElement()
      ..style.border = "2px solid white"
      ..style.padding = "1em"
      ..style.margin = "0.5em"
      ..append(new DivElement()
          ..append(_showItemImageBorders)
          ..append(_showItemImageBordersLabel));

  void initialize() {
    element.style.left = "";
    element.style.top = "0px";
    element.style.right = "0px";
    element.style.width = "";
    element.style.height = "";
  }

  Stream get onShowItemImageBordersChange => _showItemImageBorders.onChange;
}
