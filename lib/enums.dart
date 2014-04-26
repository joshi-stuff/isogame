library enums;


abstract class Enum {
  static final _values = new Map<Type, Map<String, Enum>>();

  static Iterable values(Type t) => _values[t].values;

  Enum(Type type, this.name) {
    var map = _values[type];

    if (map == null) {
      map = new Map<String, Enum>();
      _values[type] = map;
    }

    map[this.name] = this;
  }

  final String name;

  String toString() => name;
}

