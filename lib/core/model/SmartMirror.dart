import 'package:smart_mirror/core/model/User.dart';

class SmartMirror {
  static final SmartMirror _smartMirror = SmartMirror._internal();
  final List<Future<User>> _users;
  User? activeUser;

  factory SmartMirror() {
    return _smartMirror;
  }

  SmartMirror._internal({List<Future<User>>? users, this.activeUser})
      : _users = users ?? <Future<User>>[];

  bool addUser(Future<User> user) {
    _users.add(user);
    return true;
  }

  List<Future<User>> getUsers() {
    return _users;
  }
}