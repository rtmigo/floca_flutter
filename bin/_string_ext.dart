
extension StringExt on String {
  String get quoted {
    return "'" + this.escaped + "'";
  }

  String get escaped {
    final sb = StringBuffer();
    for (final c in this.codeUnits) {
      // todo backslash after backslash
      switch (c) {
        case 9:
          sb.write('\\t');
          break;
        case 10:
          sb.write('\\n');
          break;
        case 13:
          sb.write('\\r');
          break;
        case 39:
          sb.write(r"\'");
          break;

        default:
          sb.write(String.fromCharCode(c));
      }
    }
    return sb.toString();
  }
}
