import 'dart:collection';
import 'dart:io';

import 'pair.dart';
import 'state.dart';
import 'symbol.dart';

class DFSM {
  List<DFSMSymbol> _symbols;
  List<State> _states;

  DFSM(this._symbols, this._states);
  factory DFSM.copy(DFSM source) {
    return DFSM(source.symbols, source.states);
  }
  factory DFSM.fromFile(String filename) {
    var file = File(filename);
    var states = <State>[];

    var lines = file.readAsLinesSync();
    var symbols = lines[0]
        .trim()
        .split(RegExp('\\s+'))
        .map((e) => DFSMSymbol(e))
        .toList(); // в первой лении лежат символы

    // после - описания состояний
    for (var i = 1; i < lines.length; i++) {
      var state = State.fromString(lines[i], symbols);
      states.add(state);
    }
    return DFSM(symbols, states);
  }

  bool equals(DFSM other) {
    var q = Queue<Pair<State>>();
    var otherStates = other.states;
    var p = Pair<State>(_states[0], otherStates[0]);
    var used = HashSet<Pair>();
    q.push(p);
    while (q.isNotEmpty) {
      p = q.pop();
      var f = p.first;
      var s = p.second;
      // если кто-то финальный, а кто-то нет
      if (f.isFinal ^ s.isFinal) {
        return false;
      }
      used.add(p);
      for (var sym in _symbols) {
        var nt1 = f.getStateName(sym);
        var nt2 = s.getStateName(sym);
        // если по символу у одного из состяний нет перехода - плохо
        if ((nt1 == null) ^ (nt2 == null)) {
          return false;
        } else if (nt1 == null && nt2 == null) {
          // если у обоих нет - просто пропускаем символ
          continue;
        }
        // достаем состояния, в которые мы переходим из прошлых состояний по символу sym
        var t1 = _states.firstWhere((element) => element.name == nt1);
        var t2 = otherStates.firstWhere((element) => element.name == nt2);
        p = Pair(t1, t2);
        if (!used.contains(p)) {
          q.push(p);
        }
      }
    }
    return true;
  }

  factory DFSM.withPrefix(DFSM other) {
    var states = other.states;
    _depthCheck(states, states.first.name, HashSet<String>());
    return DFSM(other.symbols, states);
  }

  // по сути это поиск в глубину, где мы помечаем как финальные все вершины,
  // из которых достижимы финальные
  static bool _depthCheck(
      List<State> states, String curName, HashSet<String> checked) {
    var state = states.firstWhere((element) => element.name == curName);
    // если уже были, пропускаем
    if (checked.contains(state.name)) {
      return false;
    }
    var isFinal = state.isFinal;
    // в финальное состояние может вести несколько путей
    if (!isFinal) {
      checked.add(state.name);
    }
    for (var symbol in state.transitions.keys) {
      var nextName = state.getStateName(symbol);
      // если пустой переход или цикл, пропускаем. эта проверка необходима,
      // т.к. финальные состояния не вносятся в хэш посещенных
      if (nextName == null || nextName == curName) {
        continue;
      }
      // умный компилятор не заходит в функцию, если isFinal == true, так что пришлось поменять их местами
      isFinal = _depthCheck(states, nextName, checked) || isFinal;
    }
    state.setFinal(isFinal); // ссылочная модель, так что можем так делать
    return isFinal; // возвращаем, повстречали ли мы финальное состояние
  }

  List<DFSMSymbol> get symbols {
    var symbols = <DFSMSymbol>[];
    _symbols.forEach(
      (element) {
        symbols.add(DFSMSymbol.copy(element));
      },
    );
    return symbols;
  }

  List<State> get states {
    var states = <State>[];
    _states.forEach(
      (element) {
        states.add(State.copy(element));
      },
    );
    return states;
  }

  String asString() {
    var sb = StringBuffer();
    _symbols.forEach(
      (symbol) {
        sb.write('\t');
        sb.write(symbol.asString());
      },
    );
    sb.write('\n');
    _states.forEach(
      (state) {
        sb.write(state.asString());
        sb.write('\n');
      },
    );
    return sb.toString();
  }
}
