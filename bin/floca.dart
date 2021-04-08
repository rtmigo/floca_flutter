// SPDX-FileCopyrightText: (c) 2021 Artёm IG <github.com/rtmigo>
// SPDX-License-Identifier: MIT

import 'dart:io';

import 'package:floca/convert.dart';

void main(List<String> arguments) {
  if (arguments.length < 2) {
    print('Usage: floca <source.csv> <generated.dart>');
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
