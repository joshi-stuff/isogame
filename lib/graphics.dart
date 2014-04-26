library graphics;

import 'dart:html';
import 'dart:math';


////////////////////////////////////////////////////////////////////////////////////////////////////
// POINT
////////////////////////////////////////////////////////////////////////////////////////////////////
class Point {
  static final ORIGIN = new Point(0, 0);

  int _x;
  int _y;

  Point(this._x, this._y);

  int get x => _x;

  int get y => _y;

  String toString() => "($x, $y)";

  Point scale(Size factor) => new Point(x * factor.width, y * factor.height);
}

class MutablePoint extends Point {
  MutablePoint([int x = 0, int y = 0]) : super(x, y);

  void set x(int x) {
    _x = x;
  }

  void set y(int y) {
    _y = y;
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
// SIZE
////////////////////////////////////////////////////////////////////////////////////////////////////
class Size {
  static final EMPTY = new Size(0, 0);

  final int width;
  final int height;

  Size(this.width, this.height);

  Size scale(Size factor) => new Size(width * factor.width, height * factor.height);

  String toString() => "[$width x $height]";
}

////////////////////////////////////////////////////////////////////////////////////////////////////
// RECTANGLE
////////////////////////////////////////////////////////////////////////////////////////////////////
class Rectangle {
  static final ORIGIN = new Rectangle(Point.ORIGIN, Size.EMPTY);

  Point _position;
  Size _size;

  Rectangle(this._position, this._size);

  Point get position => _position;

  Size get size => _size;

  String toString() => "$_position $_size";

  int get diagonalLength {
    final squaredSize = _size.scale(_size);
    return sqrt(squaredSize.width + squaredSize.height).round();
  }
}

class MutableRectangle extends Rectangle {
  MutableRectangle([Point position, Size size]) : super((position == null) ? Point.ORIGIN :
      position, (size == null) ? Size.EMPTY : size);

  void set position(Point position) {
    _position = position;
  }

  void set size(Size size) {
    _size = size;
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
// WIDGET
////////////////////////////////////////////////////////////////////////////////////////////////////
abstract class Widget {
  Element _element;
  MutableRectangle _bounds = new MutableRectangle();
  int _level = 0;

  Element get element {
    if (_element == null) {
      _element = createElement()
          ..className = runtimeType.toString()
          ..style.position = "absolute";

      bounds = Rectangle.ORIGIN;
      level = 0;

      initialize();
    }

    return _element;
  }

  Element createElement();

  void initialize() {
  }

  void set bounds(Rectangle bounds) {
    position = bounds.position;
    size = bounds.size;
  }

  Rectangle get bounds => _bounds;

  Point get position => _bounds.position;

  void set position(Point position) {
    _bounds.position = position;

    element.style.left = "${position.x}px";
    element.style.top = "${position.y}px";
  }

  Size get size => _bounds._size;

  void set size(Size size) {
    _bounds.size = size;

    element.style.width = "${size.width}px";
    element.style.height = "${size.height}px";
  }

  int get level => _level;

  void set level(int level) {
    _level = level;
    element.style.zIndex = "${level}";
  }

  void add(Widget child) {
    child._attach(element);
  }

  void _attach(Element parent) {
    parent.append(element);
  }
}
