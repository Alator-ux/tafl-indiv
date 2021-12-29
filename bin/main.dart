import 'dart:io';

import 'package:tafya/dfsm.dart';

void main(List<String> arguments) {
  String? line;
  // print(
  //     'Если вы хотите выполнить задание 7, введите 1. Если задание 16, введите 2');
  // while (true) {
  // line = stdin.readLineSync();
  //   line = '1';
  //   if (line == null || (line != '1' && line != '2')) {
  //     print('Неверное значение');
  //   } else {
  //     break;
  //   }
  // }
  print('Задание 7');
  var dfsm = DFSM.fromFile('input.txt');
  var dfsm1 = DFSM.fromFile('input1.txt');
  print('Первый автомат:\n' + dfsm.asString());
  print('Второй автомат:\n' + dfsm1.asString());
  print('Автоматы равны: ' + dfsm.equals(dfsm1).toString());

  print('Задание 16');
  var dfsm2 = DFSM.fromFile('input3.txt');
  print('Исходный автомат:\n' + dfsm2.asString());
  var dfsm3 = DFSM.withPrefix(dfsm2);
  print('Новый автомат:\n' + dfsm2.asString());
  print(dfsm3.asString());
  stdin.readLineSync();
}
