import 'package:flutter/material.dart';
import 'package:smart_mirror/core/model/Task/ITask.dart';

class TaskViewController extends StatefulWidget {
  const TaskViewController({Key? key}) : super(key: key);

  @override
  _TaskViewControllerState createState() => _TaskViewControllerState();
}

class _TaskViewControllerState extends State<TaskViewController> {
  List<ITask> _tasks = <ITask>[];
  List<ITask> _filteredTasks = <ITask>[];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

}