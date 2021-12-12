import 'dart:convert';
import 'dart:math';

import 'package:characters/characters.dart';
import 'package:cryptography/cryptography.dart';

class Secure {
  static final rng = Random();
  static final nonceLength = 16;

  static final passEncoding = Pbkdf2(
    macAlgorithm: Hmac.sha256(),
    iterations: 100000,
    bits: 128,
  );

  static List<int> getNonce() {
    return List<int>.generate(
      nonceLength,
          (idx) => rng.nextInt(2 ^ 32),
      growable: false,
    );
  }

  static Future<String> getKeyHash(List<int> code, List<int> nonce) async {
    var keyBytes = await getKeyBytes(code, nonce);
    var hashBytes =
    List<int>.filled(keyBytes.length + nonce.length, 0, growable: false);
    List.copyRange(hashBytes, 0, nonce);
    List.copyRange(hashBytes, nonce.length, keyBytes);
    return base64UrlEncode(hashBytes);
  }

  static Future<List<int>> getKeyBytes(List<int> code, List<int> nonce) async {
    return await (await getKey(code, nonce)).extractBytes();
  }

  static Future<SecretKey> getKey(List<int> code, List<int> nonce) async {
    var key = await passEncoding.deriveKey(
      secretKey: SecretKey(code),
      nonce: nonce,
    );
    return key;
  }

  static List<int>? tryConvert(String input) {
    var output = <int>[];
    for (var char in input.characters) {
      var maybeInt = int.tryParse(char);
      if (maybeInt == null) return null;
      output.add(maybeInt);
    }
    return output;
  }

  static Future<bool> verifyCodeAgainstHash(
      String _passHash, List<int> code) async {
    var hashBytes = base64Decode(_passHash);
    var nonce = hashBytes.sublist(0, nonceLength);
    return _passHash == (await getKeyHash(code, nonce));
  }
}