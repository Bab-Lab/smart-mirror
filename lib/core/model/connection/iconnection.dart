import 'package:smart_mirror/core/model/user.dart';

abstract class IConnection {
  static final appName = 'com.lab.bab.smart_mirror';
  static final redirectUrl = appName + ':/';

  final User user;
  final String name;
  final DateTime lastAccessed;

  IConnection({required this.user, required this.name, DateTime? lastAccessed})
      : lastAccessed = lastAccessed ?? DateTime.utc(-271821,04,20);

  Future<void> connect();
  Future<void> disconnect();
}