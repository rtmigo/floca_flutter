[![Pub Package](https://img.shields.io/pub/v/floca.svg)](https://pub.dev/packages/floca)
[![pub points](https://badges.bar/floca/pub%20points)](https://pub.dev/floca/tabular/score)

# [floca](https://github.com/rtmigo/floca)

Floca is a **Fl**utter **loca**lization library.

Say, you have an Excel spreadsheet like this:

| property | en     | es      | ru      | hi  |
|----------|--------|---------|---------|-----|
| greeting | hi!    | hola!   | привет! | हाय! |
| farewell | bye    | adiós   | пока    |अलविदा|

Floca will let you access its content like this:

``` dart
Widget build(BuildContext context) {
  // getting the strings in proper language
  var a = context.i18n.greeting;
  var b = context.i18n.farewell;
  ...
}  
```

# How Floca works

Floca is a command-line app, that takes your `.csv` spreadsheet and generates 
a `.dart` file.

Then you import the generated file in the project and get all the needed 
functionality, including the localized strings:

```dart
import "newly_generated.dart";
```

This approach gives you maximum compatibility and performance. 
In addition, many potential errors are prevented at compile time.



# Install

Update `pubspec.yaml`: 

``` yaml
dependencies:
  flutter_localizations:
    sdk: flutter
    
dev_dependencies:
  floca: any
```

Get:

``` bash
$ flutter pub get
```

Check it runs:

``` bash
$ flutter pub run floca --help
```



# Use

#### 1. Create the spreadsheet

| property | en     | es      | ru      | hi  |
|----------|--------|---------|---------|-----|
| greeting | hi!    | hola!   | привет! | हाय! |
| farewell | bye    | adiós   | пока    |अलविदा|

Save it as `.csv` file, say, `string_constants.csv`.

#### 2. Generate a .dart file from it

```bash
$ flutter pub run floca string_constants.csv lib/string_constants.dart
```

#### 3. Provide arguments to MaterialApp

``` dart
import 'string_constants.dart'; // file we created with floca

MaterialApp(
  ...
  supportedLocales: supportedLocales, // add this
  localizationsDelegates: localizationsDelegates, // and this
  ...
);
```

#### 4. Get localized text in your app

``` dart
import 'string_constants.dart'; // file we created with floca

Widget build(BuildContext context) {
  // now [context] has a new property [.i18n]  
  String s = context.i18n.greeting;
  return Text(s); 
}
```
