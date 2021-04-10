// SPDX-FileCopyrightText: (c) 2021 Artёm IG <github.com/rtmigo>
// SPDX-License-Identifier: MIT

import 'dart:io';

import 'package:floca/floca.dart';

void printUsage() {
  print('Usage: floca <source.csv> <generated.dart>');
  print('Options:');
  print('  --help   Show this message and exit');
  print('  --subst  Substitute unset values with values from other locales');
}

class UnexpectedArgumentError extends FlocaError {
  UnexpectedArgumentError(this.argument): super('Unexpected argument: $argument');
  final String argument;
}

class UsageError extends FlocaError {
  UsageError(): super('');
}


class FileExtensionError extends FlocaError {
  FileExtensionError(this.filename): super('Unexpected file extension: $filename');
  final String filename;
}

void main(List<String> arguments) {
  try {
    mainInner(arguments);
  } on UsageError {
    printUsage();
  } on FlocaError catch (e) {
    print(e.message);
    exit(1);
  }
}

void mainInner(List<String> arguments) {
  if (arguments.map((e) => e.toLowerCase()).contains('--help')) {
    printUsage();
    exit(0);
  }

  final optional = arguments.where((s) => s.startsWith('--')).map((s) => s.toLowerCase()).toList();
  final positional = arguments.where((s) => !s.startsWith('--')).toList();
  assert(optional.length + positional.length == arguments.length);

  if (positional.length < 2) {
    throw UsageError();
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

  bool endsAny(String path, Iterable<String> suffixes) {
    path = path.toLowerCase();
    return suffixes.any((suf) => path.endsWith(suf));
  }

  if (!endsAny(csvFilename, ['.csv', '.csv.test'])) {
    throw FileExtensionError(csvFilename);
  }

  if (!endsAny(dartFilename, ['.dart', '.dart.test'])) {
    throw FileExtensionError(dartFilename);
  }

  csvFileToDartFile(File(csvFilename), File(dartFilename), tryOtherLocales: subst);
}
