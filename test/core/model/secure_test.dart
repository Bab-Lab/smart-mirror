import 'package:smart_mirror/core/model/security.dart';
import 'package:test/test.dart';

void main() {
  test('Making and verifying passcodes', () async {
    final nonce = Secure.getNonce();
    final code = [1, 2, 3, 4];
    final keyBytes = await Secure.getKeyHash(code, nonce);

    expect(await Secure.verifyCodeAgainstHash(keyBytes, code), true);
  });
}
