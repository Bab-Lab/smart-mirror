import 'package:smart_mirror/core/model/Connection/IConnection.dart';
import 'package:smart_mirror/core/model/User.dart';

abstract class ITask {
  String uuid;
  String name;
  String description;
  IConnection connection;
  DateTime dueDate;
  String timeZone;
  List<User> users;

  ITask({required this.uuid, required this.name, required this.description,
         required this.connection, required this.dueDate, required this.timeZone,
         required this.users});
}