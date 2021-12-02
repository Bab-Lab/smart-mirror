import 'dart:math';

import 'package:cryptography/cryptography.dart';
import 'package:smart_mirror/core/model/Connection/IConnection.dart';
import 'package:smart_mirror/core/model/SmartMirror.dart';
import 'package:smart_mirror/core/model/Task/ITask.dart';

class User {
  static final rng = Random();
  static final nonceLength = 16;

  static final passEncoding = Pbkdf2(
    macAlgorithm: Hmac.sha256(),
    iterations: 100000,
    bits: 128,
  );

  final SmartMirror smartMirror;
  final String name;
  List<int> _passHash;
  List<int> _nonce;
  final List<IConnection> _connections;
  final List<ITask> _tasks;
  final List<ITask> newTasks;

  User({required this.smartMirror, required this.name,
        required List<int> passhash, required List<int> nonce,
        List<IConnection>? connections,
        List<ITask>? tasks, List<ITask>? newTasks})
      : _passHash = passhash,
        _nonce = nonce,
        _connections = connections ?? <IConnection>[],
        _tasks = tasks ?? <ITask>[], newTasks = newTasks ?? <ITask>[];

  static List<int> getNonce() {
    var nonce = <int>[];
    for (var idx = 0; idx < nonceLength; idx++){
      nonce.add(rng.nextInt(2^32));
    }
    return nonce;
  }

  static Future<List<int>> getKeyBytes(List<int> code, List<int> nonce) async {
    return (await getKey(code, nonce)).extractBytes();
  }

  static Future<SecretKey> getKey(List<int> code, List<int> nonce) async {
    var key = await passEncoding.deriveKey(
      secretKey: SecretKey(code),
      nonce: nonce,
    );
    return key;
  }

  Future<bool> verifyCode(List<int> code) async {
    return _passHash == (await getKeyBytes(code, _nonce));
  }
}