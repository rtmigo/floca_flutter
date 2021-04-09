// SPDX-FileCopyrightText: (c) 2021 Artёm IG <github.com/rtmigo>
// SPDX-License-Identifier: MIT

import 'dart:io';

import 'package:floca/convert.dart';

void printUsage() {
  print('Usage: floca <source.csv> <generated.dart>');
  print('Options:');
  print('  --help   Show this message and exit');
  print('  --subst  Substitute unset values with values from other locales');
}

class UnexpectedArgumentError extends FlocaError {
  UnexpectedArgumentError(this.argument);

  final String argument;
}

void main(List<String> arguments) {
  if (arguments.map((e) => e.toLowerCase()).contains('--help')) {
    printUsage();
    exit(0);
  }

  final optional = arguments.where((s) => s.startsWith('--')).map((s) => s.toLowerCase()).toList();
  final positional = arguments.where((s) => !s.startsWith('--')).toList();
  assert(optional.length + positional.length == arguments.length);

  if (positional.length < 2) {
    printUsage();
    exit(1);
  }

  bool subst = false;
  for (var opt in optional) {
    switch (opt) {
      case '--subst':
        subst = true;
        break;
      default:
        throw UnexpectedArgumentError(opt);
    }
  }

  final csvFilename = arguments[0];
  final dartFilename = arguments[1];

  if (!csvFilename.toLowerCase().endsWith('.csv')) {
    throw 'Unexpected CSV filename: $csvFilename';
  }

  if (!dartFilename.toLowerCase().endsWith('.dart')) {
    throw 'Unexpected Dart filename: $dartFilename';
  }

  csvFileToDartFile(File(csvFilename), File(dartFilename), tryOtherLocales: subst);
}
