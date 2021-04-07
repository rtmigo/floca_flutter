A simple command-line application.

Created from templates made available by Stagehand under a BSD-style
[license](https://github.com/dart-lang/stagehand/blob/master/LICENSE).

Add floca to pubspec.yaml: 

``` yaml
dev_dependencies:
  floca: any
```

Update dependencies:

``` bash
flutter pub get
```

Run floca to convert CSV to DART:

``` bash
flutter pub run floca:floca path/to/i18n.csv lib/i18n.dart
```

Import the generated file:

``` dart
import 'i18n.dart';
```


