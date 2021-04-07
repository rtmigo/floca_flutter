import 'dart:io';

import 'package:floca/convert.dart';


void main(List<String> arguments) {

  if (arguments.length<2) {
    print('Usage: floca <source.csv> <generated.dart>');
    exit(1);
  }

  csvFileToDartFile(File(arguments[0]), File(arguments[1]));
  //print('Hello world!');
}
