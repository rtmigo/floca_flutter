import 'package:test/test.dart';
import 'dart:io';
import 'package:path/path.dart' show dirname, join;
import 'package:floca/convert.dart';

void main() {
  test('tst', () {
    final csvFile = File('test/data/src.csv');
    final outFile = File('test/data/dst.dart.txt');
    csvFileToDartFile(csvFile, outFile);

    //final z = join(dirname(Platform.script.path), 'data/src.csv');
    print('--');
    //print(Platform.script.c);
    print('---');
  });
}