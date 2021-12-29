class DFSMSymbol {
  final String _str;

  DFSMSymbol(String str) : _str = str;
  factory DFSMSymbol.copy(DFSMSymbol s) {
    return DFSMSymbol(s.strOriginal);
  }

  String get str => _str.toLowerCase();
  String get strOriginal => _str;

  @override
  bool operator ==(Object other) {
    // Равенству не важен регистр
    return other is DFSMSymbol && str == other.str;
  }

  @override
  int get hashCode => str.hashCode; // Хэш коду соответственно тоже

  String asString() {
    return _str;
  }
}
