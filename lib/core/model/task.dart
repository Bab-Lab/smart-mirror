import 'package:smart_mirror/core/model/connection/iconnection.dart';

class Task {
  String uuid;
  String name;
  String? description;
  IConnection connection;
  DateTime dateTime;
  DateTime? endDateTime;

  Task({required this.uuid, required this.name, required this.description,
         required this.connection, required this.dateTime, this.endDateTime});
}