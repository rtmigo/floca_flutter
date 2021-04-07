import 'package:test/test.dart';
import 'dart:io';
import 'package:intl/locale.dart';
import 'package:path/path.dart' show dirname, join;
import 'package:floca/convert.dart';

void main() {

  test('locale to title case', () {
    expect(localeToTitleCase(Locale.parse('by')), 'By');
    expect(localeToTitleCase(Locale.parse('en-US')), 'EnUs');
    expect(localeToTitleCase(Locale.parse('iw')), 'He'); // 'iw' is deprecated variant of 'he'
    expect(localeToTitleCase(Locale.parse('zh-Hans-CN')), 'ZhHansCn');
  });

  test('parse', () {
    final csvFile = File('test/data/src.csv');
    final plc = ParsedLangConstants(csvFile);
    expect(plc.locales.map((e) => e.toLanguageTag()), ['en-US', 'eo', 'ru']);
    expect(plc.localeToPropertyToText[Locale.parse('ru')]?['language'], 'Язык');
    expect(plc.localeToPropertyToText[Locale.parse('ru')]?['termsOfUse'], '');
    expect(plc.localeToPropertyToText[Locale.parse('en-US')]?['termsOfUse'], 'Terms of Use');

    expect(plc.text(Locale.parse('ru'), 'language'), 'Язык');
    expect(plc.text(Locale.parse('en-US'), 'termsOfUse'), 'Terms of Use');
    expect(plc.text(Locale.parse('ru'), 'termsOfUse'), 'Terms of Use'); // missing in ru, present in en
  });

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