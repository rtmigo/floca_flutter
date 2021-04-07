Floca is for internationalizing Flutter apps.

Say, you have an Excel spreadsheet like this:

| property | en     | es      | ru      | hi  |
|----------|--------|---------|---------|-----|
| greeting | hi!    | hola!   | привет! | हाय! |
| farewell | bye    | adiós   | пока    |अलविदा|

`floca` will let you access its content like this:

``` dart
Widget build(BuildContext context) {
  // getting the strings in proper language
  var a = context.i18n.greeting;
  var b = context.i18n.farewell;
  ...
}  
```

An attempt to use constants not specified in the spreadsheet will be prevented 
at compile time:

``` dart
Widget build(BuildContext context) {
  var c = context.i18n.nonexistent; // COMPILE-TIME ERROR!
  ...
}  
```

# What Floca does

Floca takes your `.csv` spreadsheet and generates a `.dart` file.
```dart
import "newly_generated.dart";
  // this import adds the .i18n extension on BuildContext objects
```

So all the localized strings are just `String` constants.

# Install

Update pubspec.yaml: 

``` yaml
dependencies:
  flutter_localizations:  # a flutter component unrelated to floca
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
$ flutter pub run floca:floca --version
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
$ flutter pub run floca:floca string_constants.csv string_constants.dart
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
