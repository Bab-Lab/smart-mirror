import 'package:smart_mirror/core/model/Task/itask.dart';
import 'package:smart_mirror/core/model/connection/iconnection.dart';
import 'package:smart_mirror/core/model/security.dart';
import 'package:smart_mirror/core/model/smart_mirror.dart';

class  User extends Secure {
  final SmartMirror smartMirror;
  final String name;
  String _passHash;
  final List<IConnection> _connections;
  final List<ITask> _tasks;
  final List<ITask> newTasks;

  User(
      {required this.smartMirror,
      required this.name,
      required String passhash,
      List<IConnection>? connections,
      List<ITask>? tasks,
      List<ITask>? newTasks})
      : _connections = connections ?? <IConnection>[],
        _tasks = tasks ?? <ITask>[],
        newTasks = newTasks ?? <ITask>[],
        _passHash = passhash;

  Future<bool> verifyCode(List<int> code) async {
    return Secure.verifyCodeAgainstHash(_passHash, code);
  }

  List<IConnection> getConnections() {
    return _connections;
  }
}