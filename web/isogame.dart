library isogame;

import 'dart:html';
import 'dart:math';

import 'package:isogame/board.dart';
import 'package:isogame/controls.dart';
import 'package:isogame/graphics.dart';
import 'package:isogame/items.dart';


void main() {
  var terrain = _createTerrain();
  terrain.attach(document.body);

  var debugPanel = new DebugPanel();
  debugPanel.onShowItemImageBordersChange.listen((ev) {
    terrain.detach();
    ITEM_IMAGE_BORDER = !ITEM_IMAGE_BORDER;
    terrain = _createTerrain();
    terrain.attach(document.body);
  });
  debugPanel.attach(document.body);
}

Terrain _createTerrain() {
  final terrainSize = new Size(20, 20);
  final terrain = new Terrain(terrainSize);
  final rnd = new Random();
  final position = new MutablePoint();

  for (int x = 0; x < terrain.tileSize.width; x++) {
    for (int y = 0; y < terrain.tileSize.height; y++) {
      position
          ..x = x
          ..y = y;

      var tile = new Tile(TileType.GRASS);

      /*
      if(rnd.nextInt(100)<20) {
        tile = new Tile(TileType.SEA);
      } else if(rnd.nextInt(100)<20) {
        tile = new Tile(TileType.SAND);
      } else if(rnd.nextInt(100)<8) {
        tile = new Tile(TileType.SAND);
        terrain.addItem(x, y, new Tree());
      }
      */
      if (x == 5 && y == 5) {
        tile = new Tile(TileType.SAND);
      }
      if (x == 10 && y == 10) {
        tile = new Tile(TileType.SAND);
      }

      terrain.tiles[position] = tile;
    }
  }

  for (int x = 0; x < terrain.tileSize.width; x++) {
    for (int y = 0; y < terrain.tileSize.height; y++) {

      position
          ..x = x
          ..y = y;

      if (x == 5 && y == 5) {
        terrain.addItem(position, new Tree()..highlight = "red");
      }
      if (x == 10 && y == 10) {
        terrain.addItem(position, new Castle()..highlight = "blue");
      }
    }
  }

  return terrain;
}

