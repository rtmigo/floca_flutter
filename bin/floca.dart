// SPDX-FileCopyrightText: (c) 2021 Artёm IG <github.com/rtmigo>
// SPDX-License-Identifier: MIT

import 'dart:io';

import 'package:floca/convert.dart';

void printUsage() {
  print('Usage: floca <source.csv> <generated.dart>');
}

void main(List<String> arguments) {

  if (arguments.map((e) => e.toLowerCase()).contains('--help')) {
    printUsage();
    exit(0);
  }

  if (arguments.length < 2) {
    printUsage();
    exit(1);
  }

  final csvFilename = arguments[0];
  final dartFilename = arguments[1];

  if (!csvFilename.toLowerCase().endsWith('.csv')) {
    throw 'Unexpected CSV filename: $csvFilename';
  }

  if (!csvFilename.toLowerCase().endsWith('.dart')) {
    throw 'Unexpected Dart filename: $csvFilename';
  }

  csvFileToDartFile(File(csvFilename), File(dartFilename));
}
