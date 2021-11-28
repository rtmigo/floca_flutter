import 'package:test/test.dart';
import '../bin/_string_ext.dart';
void main() {
  test('escape', () {
    expect('abc'.escaped, 'abc');
    expect('line1\nline2'.escaped, r'line1\nline2');
    expect("rock'n'roll".escaped, r"rock\'n\'roll");
    //expect('line1\\\nline2'.escaped, r'line1\nline2');
  });
}
