import 'package:smart_mirror/core/model/connection/google_connection.dart';
import 'package:smart_mirror/core/model/connection/iconnection.dart';
import 'package:smart_mirror/core/model/connection/trello_connection.dart';
import 'package:smart_mirror/core/model/task.dart';

class User {
  final Map<String, Task> _tasks;

  GoogleConnection? _googleConnection;
  TrelloConnection? _trelloConnection;

  User({
    List<IConnection>? connections,
    Map<String, Task>? tasks,
    List<String>? newTasks,
    bool hasGoogle = false,
    bool hasTrello = false
  }) :  _tasks = tasks ?? <String, Task>{} {
    if(hasGoogle) {
      print('User had google before!');
      _googleConnection = GoogleConnection(user: this);
    }
    if(hasTrello) {
      print('User had trello before!');
      _trelloConnection = TrelloConnection(user: this);
    }
  }

  Future<bool> connectAndLoad() async {
    for (var connection in getConnections()) {
      if (!await connection.connect()) return false;
      var tasks = await connection.getTasks();
      if (tasks == null) return false;
      else _tasks.addAll(tasks);
    }
    return true;
  }

  List<Task> getTasks() {
    return _tasks.values.toList();
  }

  void setGoogle(GoogleConnection connection) {
    _googleConnection = connection;
  }
  bool hasGoogle() => _googleConnection != null;

  void setTrello(TrelloConnection connection) {
    _trelloConnection = connection;
  }
  bool hasTrello() => _trelloConnection != null;

  bool hasAllConnection() => hasGoogle() && hasTrello();

  List<IConnection> getConnections() {
    var connections = <IConnection>[];
    if (_googleConnection != null) connections.add(_googleConnection!);
    if (_trelloConnection != null) connections.add(_trelloConnection!);
    return connections;
  }
}