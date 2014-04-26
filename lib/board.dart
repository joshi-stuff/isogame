library board;

import 'dart:html' hide Rectangle, Point;

import 'package:isogame/enums.dart';
import 'package:isogame/graphics.dart';


bool TERRAIN_SCALE = true;
bool TERRAIN_ROTATE = true;
bool ITEM_ROTATE = true;
bool ITEM_IMAGE_BORDER = false;


////////////////////////////////////////////////////////////////////////////////////////////////////
// TERRAIN
////////////////////////////////////////////////////////////////////////////////////////////////////
class Terrain extends Widget with Attach {
  final Size tileSize;
  List<List<Tile>> _tiles;
  TilesAccessor _tilesAccesor;

  Terrain(this.tileSize) {
    _tiles = new List<List<Tile>>.generate(tileSize.width, (x) => new List<Tile>(tileSize.height));
    _tilesAccesor = new TilesAccessor(this);
  }

  Element createElement() => new DivElement()
      ..style.setProperty("-webkit-transform",
          "${TERRAIN_SCALE ? 'scaleY(0.5)' : ''} ${TERRAIN_ROTATE ? 'rotate(45deg)' : ''}")
      ..style.backgroundColor = "#222";

  void initialize() {
    super.initialize();

    size = tileSize.scale(Tile.SIZE);

    // TODO: positioning algorithm doesn't work for non square terrains
    int x = (bounds.diagonalLength - bounds.size.width) ~/ 2;

    var scaledSize = new Size(size.width, size.height ~/ 2);
    var scaledBounds = new Rectangle(Point.ORIGIN, scaledSize);

    int y = (bounds.diagonalLength - scaledBounds.diagonalLength) ~/ 2;

    position = new Point(x, -y);
  }

  TilesAccessor get tiles => _tilesAccesor;

  void addItem(Point tilePosition, Item item) {
    // TODO: register item or multiitem
    item.position = tilePosition.scale(Tile.SIZE);
    add(item);
  }

  void _addTile(Point tilePosition, Tile tile) {
    _tiles[tilePosition.x][tilePosition.y] = tile;
    tile.position = tilePosition.scale(Tile.SIZE);
    add(tile);
  }
}

class TilesAccessor {
  Terrain _terrain;

  TilesAccessor(this._terrain);

  Tile operator [](Point tilePosition) => _terrain._tiles[tilePosition.x][tilePosition.y];

  void operator []=(Point tilePosition, Tile tile) {
    _terrain._addTile(tilePosition, tile);
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
// TILES
////////////////////////////////////////////////////////////////////////////////////////////////////
class TileType extends Enum {
  static final DESERT = new TileType("DESERT");
  static final GRASS = new TileType("GRASS");
  static final ROCK = new TileType("ROCK");
  static final SAND = new TileType("SAND");
  static final SEA = new TileType("SEA");

  static Iterable<TileType> get values => Enum.values(TileType);

  TileType(String name) : super(TileType, name);
}

class Tile extends Widget {
  static final SIZE = new Size(45, 45);
  static final BOUNDS = new Rectangle(Point.ORIGIN, Tile.SIZE);
  static final DIAGONAL_LENGTH = Tile.BOUNDS.diagonalLength;

  final TileType type;
  ImageElement _image;

  Tile(this.type);

  Element createElement() {
    _image = new ImageElement()..src = "rc/Tile/${type.name}.png";

    return new DivElement()
        ..style.border = "1px solid #222"
        ..append(_image);
  }

  void initialize() {
    super.initialize();

    size = SIZE;
  }

  void set size(Size size) {
    super.size = size;
    _image.style.width = "${size.width}px";
    _image.style.height = "${size.height}px";
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
// ITEM
////////////////////////////////////////////////////////////////////////////////////////////////////
abstract class Item extends Widget {
  static final SCALE = new Size(64 * Tile.SIZE.width ~/ 45, 64 * Tile.SIZE.height ~/ 45);

  final Size _tileSize;
  final int _tileHeight;
  Element _image;

  final _placeHolder = new DivElement()
      ..style.position = "absolute"
      ..style.left = "0"
      ..style.top = "0"
      ..style.right = "0"
      ..style.bottom = "0"
      ..style.opacity = "0.4";

  Item(this._tileSize, this._tileHeight);

  Element createElement() {
    _image = createImage()
        ..style.position = "absolute"
        ..style.border = ITEM_IMAGE_BORDER ? "2px solid blue" : ""
        ..style.setProperty("-webkit-transform", "${ITEM_ROTATE ? 'rotate(-45deg)' : ''}");

    return new DivElement()
        ..append(_placeHolder)
        ..append(_image);
  }

  Element createImage();

  void initialize() {
    super.initialize();
    size = _tileSize.scale(Tile.SIZE);
  }

  void set size(Size size) {
    super.size = size;

    // Image size
    var bounds = new Rectangle(Point.ORIGIN, size);
    var diagonalLength = bounds.diagonalLength;
    var imageSize = new Size(diagonalLength, diagonalLength + _tileHeight * Tile.DIAGONAL_LENGTH);

    _image.style.width = "${imageSize.width}px";
    _image.style.height = "${imageSize.height}px";

    // Image position
    var imagePosition = new MutablePoint();

    imagePosition.x = size.width ~/ 2;
    imagePosition.y = size.height ~/ 2;

    imagePosition.x -= _tileHeight * Tile.SIZE.width ~/ 2;
    imagePosition.y -= _tileHeight * Tile.SIZE.height ~/ 2;

    _centerImage(imagePosition, imageSize);
  }

  void set highlight(String color) {
    _placeHolder.style.backgroundColor = (color == null) ? "" : color;
  }

  void _centerImage(Point position, Size size) {
    int x = position.x - (size.width ~/ 2);
    int y = position.y - (size.height ~/ 2);
    _image.style.left = "${x}px";
    _image.style.top = "${y}px";
  }
}
