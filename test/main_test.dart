import 'dart:io';

import 'file:///Volumes/stuff.kongo/.Lightspot/rtmigo/CabinetWs/Code/dart/floca/bin/floca_lib.dart';
import 'package:test/test.dart';

import '../bin/floca.dart' as cli;

void main() {
  File sourceFile = File('test/data/src.csv');
  File generatedFile = File('test/data/generated.dart.test');

  setUp(() {
    if (generatedFile.existsSync()) {
      generatedFile.deleteSync();
    }
  });

  test('file extension errors', () {
    assert(!generatedFile.existsSync());

    expect(() => cli.mainInner(['/tmp/source.xls', '/tmp/destination.dart']),
        throwsA(isA<cli.FileExtensionError>()));
    expect(() => cli.mainInner(['/tmp/source.csv', '/tmp/destination.cpp']),
        throwsA(isA<cli.FileExtensionError>()));

    expect(() => cli.mainInner(['/tmp/source.csv', '/tmp/destination.dart']),
        isNot(throwsA(isA<cli.FileExtensionError>())));
    expect(() => cli.mainInner(['/tmp/source.csv.test', '/tmp/destination.dart.test']),
        isNot(throwsA(isA<cli.FileExtensionError>())));
  });

  test('missing value', () {
    assert(!generatedFile.existsSync());
    expect(() => cli.mainInner([sourceFile.path, generatedFile.path]),
        throwsA(isA<MissingValueError>()));
    assert(!generatedFile.existsSync());
  });

  test('convert subst', () {
    assert(!generatedFile.existsSync());
    cli.mainInner([sourceFile.path, generatedFile.path, '--subst']);
    assert(generatedFile.existsSync());
  });

  test('no args', () {
    expect(() => cli.mainInner([]), throwsA(isA<cli.UsageError>()));
    expect(() => cli.mainInner(['/tmp/source.csv']), throwsA(isA<cli.UsageError>()));
    expect(() => cli.mainInner(['/tmp/source.csv.test', '/tmp/destination.dart.test']),
        isNot(throwsA(isA<cli.UsageError>())));
  });
}
