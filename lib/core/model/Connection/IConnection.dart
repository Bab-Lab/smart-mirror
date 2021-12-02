import 'package:smart_mirror/core/model/User.dart';

abstract class IConnection {
  final User user;
  final String name;
  final String url;
  final DateTime lastAccessed;

  IConnection({required this.user, required this.name,
               required this.url, DateTime? lastAccessed})
      : lastAccessed = lastAccessed ?? DateTime.utc(-271821,04,20);
}