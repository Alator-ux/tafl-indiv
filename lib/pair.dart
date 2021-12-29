import 'dart:collection';

class Pair<T> {
  final T first;
  final T second;
  Pair(this.first, this.second);

  @override
  bool operator ==(Object other) {
    // Пары вида Pair(f,s) и Pair(s,f) равны
    if (!(other is Pair)) {
      return false;
    }
    return first == other.first && second == other.second ||
        first == other.second && second == other.first;
  }

  @override
  int get hashCode {
    // Для пар вида Pair(f,s) и Pair(s,f) hash будет одинаковым
    var hash = 17;
    var hashMultiplikator = 79;
    var hashSum = first.hashCode + second.hashCode;
    hash = hashMultiplikator * hash * hashSum;
    return hash;
  }
}

extension QE<T> on Queue {
  T pop() {
    // Чтобы было более компактно и привычно
    var f = first;
    removeFirst();
    return f;
  }

  void push(T value) {
    // Просто чтобы было более привычно
    add(value);
  }
}
