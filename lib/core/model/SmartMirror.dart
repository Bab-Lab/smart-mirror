import 'package:smart_mirror/core/model/User.dart';

class SmartMirror {
  static final SmartMirror _smartMirror = SmartMirror._internal();
  final List<User> _users;
  User? activeUser;

  factory SmartMirror() {
    return _smartMirror;
  }

  SmartMirror._internal({List<User>? users, this.activeUser})
      : _users = users ?? <User>[];

  bool addUser(User user) {
    _users.add(user);
    return true;
  }

  List<User> getUsers() {
    return _users;
  }
}