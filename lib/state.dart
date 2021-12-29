import 'symbol.dart';

class State {
  final String _name;
  bool _isFinal;
  final Map<DFSMSymbol, String> _transitions;

  State(this._name, this._isFinal, this._transitions);
  factory State.copy(State source) {
    return State(source.name, source.isFinal, source.transitions);
  }
  factory State.fromString(String stateDesc, List<DFSMSymbol> allSymbols) {
    var desc = stateDesc.split(RegExp('\\s+')).toList();
    var name = '';
    var isFinal = false;
    var transitions = <DFSMSymbol, String>{};
    // Первым лежит имя состояние
    if (desc[0].endsWith('!') && desc[0].length > 1) {
      name = desc[0].substring(0, desc[0].length - 1);
      isFinal = true;
    } else if (desc[0].isNotEmpty) {
      name = desc[0];
    } else {
      throw Exception('Invalid state name format');
    }
    // После - переходы
    for (var i = 1; i < desc.length; i++) {
      transitions[allSymbols[i - 1]] = desc[i];
    }
    return State(name, isFinal, transitions);
  }

  void setFinal(bool isFinal) => _isFinal = isFinal;

  String get name => _name.toLowerCase();
  bool get isFinal => _isFinal;
  Map<DFSMSymbol, String> get transitions {
    var res = <DFSMSymbol, String>{};
    _transitions.forEach(
      (key, value) {
        res[DFSMSymbol.copy(key)] = value;
      },
    );
    return res;
  }

  // can be null
  String? getStateName(DFSMSymbol s) {
    // т.к. использую словарь, надо отличать обычные null'ы от отсутствия переходов по символу
    if (!_transitions.containsKey(s)) {
      throw Exception('No such symbol in dfsm - ' + s.toString());
    }
    return _transitions[s] == '-' ? null : _transitions[s];
  }

  String asString() {
    var sb = StringBuffer();
    sb.write(_name);
    sb.write(_isFinal ? '!' : '');
    _transitions.forEach(
      (key, value) {
        sb.write('\t');
        sb.write(value);
      },
    );
    return sb.toString();
  }
}
