import 'package:smart_mirror/core/model/user.dart';
import 'package:test/test.dart';

void main() {
  test('Making and verifying passcodes', () async {
    final nonce = User.getNonce();
    final code = [1, 2, 3, 4];
    final keyBytes = await User.getKeyHash(code, nonce);

    expect(await User.verifyCodeAgainstHash(keyBytes, code), true);
  });
}
