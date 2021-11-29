import 'package:test/test.dart';
import '../bin/_string_ext.dart';
void main() {
  test('escape', () {
    expect('abc'.singleQuoted, "'abc'");
    expect(r'ac\dc'.singleQuoted, r"'ac\\dc'");
    expect('line1\nline2'.singleQuoted, r"'line1\nline2'");
    expect("rock'n'roll".singleQuoted, r"'rock\'n\'roll'");
    //expect('line1\\\nline2'.escaped, r'line1\nline2');
  });
}
