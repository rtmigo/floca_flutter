import 'dart:convert';

extension StringExt on String {
  String get singleQuoted {
    // quick-and-dirty!

    const singleQuoteReplacement = 'f118a27f0b3545bdb4fbc3420bc1a177';
    // replacing single quotes with special sequence
    String text = this.replaceAll(RegExp(r"'"), singleQuoteReplacement);
    // getting the escaped string in double quotes
    text = jsonEncode(text);
    assert(text[0] == '"');
    // getting string contents (without quotes)
    text = text.substring(1, text.length - 1);
    // placing single quotes back (now prefixed by backslashes)
    text = text.replaceAll(RegExp(singleQuoteReplacement), r"\'");
    // placing string in single quotes
    text = "'" + text + "'";
    return text;
  }
}
