import 'package:crypto/crypto.dart';
import 'package:pbkdf2_dart/pbkdf2_dart.dart';
import 'package:smart_mirror/core/model/Connection/IConnection.dart';
import 'package:smart_mirror/core/model/SmartMirror.dart';
import 'package:smart_mirror/core/model/Task/ITask.dart';

class User {
  static var gen = PBKDF2(hash: sha256);

  final SmartMirror smartMirror;
  final String name;
  List<int> _passHash;
  final List<IConnection> _connections;
  final List<ITask> _tasks;
  final List<ITask> newTasks;

  User({required this.smartMirror, required this.name, required String passcode,
        List<IConnection>? connections,
        List<ITask>? tasks, List<ITask>? newTasks})
      : _passHash = getKeyFromName(passcode, name),
        _connections = connections ?? <IConnection>[],
        _tasks = tasks ?? <ITask>[], newTasks = newTasks ?? <ITask>[];

  static List<int> getKeyFromName(String code, String name) {
    return gen.generateKey(code, name, 1000, 32);
  }

  List<int> getKey(String code) {
    return getKeyFromName(code, name);
  }

  bool verifyCode(String code) {
     return getKey(code) == _passHash;
  }
}