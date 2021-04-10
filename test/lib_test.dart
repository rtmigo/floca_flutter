import 'package:test/test.dart';
import 'dart:io';
import 'package:intl/locale.dart';
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

    expect(plc.locales.map((e) => e.toLanguageTag()), ['en-US', 'es', 'ru']);
    expect(plc.localeToPropertyToText[Locale.parse('ru')]?['language'], 'Язык');
    expect(plc.localeToPropertyToText[Locale.parse('ru')]?['termsOfUse'], '');
    expect(plc.localeToPropertyToText[Locale.parse('en-US')]?['termsOfUse'], 'Terms of Use');

    expect(plc.text(Locale.parse('ru'), 'language'), 'Язык');
    expect(plc.text(Locale.parse('en-US'), 'termsOfUse'), 'Terms of Use');
  });

  test('missing values', () {
    final csvFile = File('test/data/src.csv');
    final plc = ParsedLangConstants(csvFile);

    expect(plc.text(Locale.parse('ru'), 'termsOfUse', tryOtherLocales: true), 'Terms of Use');
    expect(()=>plc.text(Locale.parse('ru'), 'termsOfUse'), throwsA(isA<MissingValueError>()));
  });

  test('tst', () {

    File sourceFile = File('test/data/src.csv');
    File generatedFile = File('test/data/generated.dart.test');
    final expectedFile = File('test/data/exp.dart.txt');

    if (generatedFile.existsSync()) {
      generatedFile.deleteSync();
    }

    csvFileToDartFile(sourceFile, generatedFile, tryOtherLocales: true);

    var expected = expectedFile.readAsStringSync();
    if (Platform.isWindows) {
      expected = expected.replaceAll('\r\n', '\n');
    }


    expect(generatedFile.readAsStringSync(), expected);
  });
}