// SPDX-FileCopyrightText: (c) 2021 Artёm IG <github.com/rtmigo>
// SPDX-License-Identifier: MIT

import 'dart:io';

import 'package:csv/csv.dart';
import 'package:intl/locale.dart';

class FlocaError extends Error {
  FlocaError(this.message);
  String message;
}

class MissingValueError extends FlocaError {
  MissingValueError(this.property, this.locale):
        super('Value $property not specified for locale $locale.');
  final String property;
  final Locale locale;
}

Iterable<Map<String, String>> dictReader(File csvFile) sync* {

  String text = csvFile.readAsStringSync().replaceAll('\r\n', '\n'); // windows

  final rowsAsListOfValues = const CsvToListConverter().convert(text,
      fieldDelimiter: csvFile.path.toLowerCase().endsWith('.tsv') ? '\t' : ',', eol: '\n');
  List<String>? columnNames;

  for (var row in rowsAsListOfValues) {
    if (columnNames == null) {
      columnNames = row.map((e) => e.toString()).toList();
      continue;
    }

    final result = <String, String>{};

    for (int i = 0; i < columnNames.length; ++i) {
      result[columnNames[i]] = (i < row.length) ? row[i] : '';
    }

    yield result;
  }
}

String beforeHash(String text) => text.split('#').first;

class ParsedLangConstants {
  ParsedLangConstants(File csvFile) {
    final propertiesSet = <String>{};

    for (var row in dictReader(csvFile)) {
      final propertyName = beforeHash(row['property'] ?? '').trim();
      if (propertyName.isEmpty) {
        continue;
      }

      for (var col in row.keys) {
        final lang = beforeHash(col).trim().toLowerCase();
        if (lang.isEmpty || lang == 'property') {
          continue;
        }

        localeToPropertyToText.putIfAbsent(
            Locale.parse(lang), () => <String, String>{})[propertyName] = row[col]!;
        propertiesSet.add(propertyName);
      }
    }

    this.properties = propertiesSet.toList()..sort();
  }

  Map<Locale, Map<String, String>> localeToPropertyToText = {};

  List<Locale> get locales {
    bool isEn(Locale l) {
      return l.languageCode == 'en';
    }

    return localeToPropertyToText.keys.toList()
      ..sort((Locale a, Locale b) {
        if (isEn(a) && !isEn(b)) {
          return -1;
        }
        if (isEn(b) && !isEn(a)) {
          return 1;
        }

        return a.toLanguageTag().compareTo(b.toLanguageTag());
      });
  }

  Iterable<Locale> _localeTagsStartingWith(Locale l) sync* {
    yield l;
    for (var otherLang in this.locales) {
      if (otherLang != l) {
        yield otherLang;
      }
    }
  }

  late List<String> properties;

  String text(Locale locale, String property, {bool tryOtherLocales = false}) {
    for (var l in _localeTagsStartingWith(locale)) {
      var result = localeToPropertyToText[l]?[property];

      if (result==null || result.isEmpty) {
        if (tryOtherLocales) {
          continue;
        } else {
          throw MissingValueError(property, locale);
        }
      }

      assert(result.isNotEmpty);

      if (l != locale) {
        print('WARNING: Using $l as '
            'fallback for $property[$locale]');
      }

      return result;
    }
    return '';
  }
}

String localeToTitleCase(Locale l) {
  String titleCase(String s) => s[0].toUpperCase() + s.substring(1).toLowerCase();
  return l.toLanguageTag().split('-').map((s) => titleCase(s)).join();
}

extension StringExt on String {
  String get quoted {
    return "'" + this.replaceAll("'", "\\'") + "'";
    //return json.encode(this);
  }
}

void csvFileToDartFile(File csvFile, File dartFile, {bool tryOtherLocales = false}) {
  final parsed = ParsedLangConstants(csvFile);

  final outputLines = [];

  void outLine([String? txt]) => outputLines.add(txt ?? '');

  outLine('// generated with Floca. See https://github.com/rtmigo/floca#readme');
  outLine();
  outLine("import 'package:flutter/widgets.dart';");
  outLine("import 'package:flutter_localizations/flutter_localizations.dart';");
  outLine("export 'package:flutter_localizations/flutter_localizations.dart';");
  outLine();

  outLine('const supportedLocales = <Locale>[');
  for (var locale in parsed.locales) {
    outLine(
        '    Locale.fromSubtags(languageCode: ${locale.languageCode.quoted}, scriptCode: ${locale.scriptCode?.quoted}, countryCode: ${locale.countryCode?.quoted}),');
  }
  outLine('  ];');

  outLine();
  outLine('abstract class FlocaStrings {');
  for (var p in parsed.properties) {
    outLine('  String get $p;');
  }
  outLine('}');

  String langToClassname(Locale lang) => 'FlocaStrings' + localeToTitleCase(lang);

  for (var lang in parsed.locales) {
    outLine();

    outLine('class ${langToClassname(lang)} implements FlocaStrings {');

    for (var p in parsed.properties) {
      final dartString = parsed.text(lang, p, tryOtherLocales: tryOtherLocales).replaceAll('\$', '\\\$').quoted;
      outLine('  @override String get $p => $dartString;');
    }

    outLine('}');
  }

  outLine();
  outLine('class FlocaDelegate extends LocalizationsDelegate<FlocaStrings> {');
  outLine('  const FlocaDelegate();');
  outLine();
  outLine('  @override');
  outLine('  Future<FlocaStrings> load(Locale locale) async {');
  outLine('    switch (locale.toLanguageTag()) {');
  for (var locale in parsed.locales.skip(1)) {
    outLine('      case ${locale.toLanguageTag().quoted}: return ${langToClassname(locale)}();');
  }
  outLine('      default: return ${langToClassname(parsed.locales.first)}();');
  outLine('    }');
  outLine('  }');
  outLine();
  outLine('  @override');
  outLine('  bool isSupported(Locale locale) => supportedLocales.contains(locale);');
  outLine();
  outLine('  @override');
  outLine('  bool shouldReload(FlocaDelegate old) => false;');

  outLine('}');
  outLine();
  outLine('''
extension FlocaBuildContextExt on BuildContext
{
  FlocaStrings get i18n {
    return Localizations.of<FlocaStrings>(this, FlocaStrings)!;
  }
}

const localizationsDelegates = <LocalizationsDelegate<dynamic>> [
  const FlocaDelegate(),
  GlobalMaterialLocalizations.delegate,
  GlobalWidgetsLocalizations.delegate
];  
  ''');

  dartFile.writeAsStringSync(outputLines.join('\n'));
}
