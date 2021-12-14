import 'package:flutter/material.dart';
import 'package:smart_mirror/core/model/connection/iconnection.dart';
import 'package:smart_mirror/core/model/user.dart';
import 'package:smart_mirror/modules/connection/connection_setup.dart';
import 'package:smart_mirror/modules/task/task_view_controller.dart';

class SmartMirrorController extends StatelessWidget {
  final User user;

  const SmartMirrorController({Key? key, required this.user})
      : super(key: key);

  static void pushNewConnection(BuildContext context, User user) {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Material(
            child: ConnectionSetup(user: user)))
    );
  }

  static void pushTaskView(
      BuildContext context, User user,
      {IConnection? startingSelection}) {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Material(
            child: buildTaskView(user, startingSelection: startingSelection)))
    );
  }

  static Widget buildTaskView(User user, {IConnection? startingSelection}) {
    return Material(child: FutureBuilder<bool>(
        future: user.connectAndLoad(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          return TasksViewController(
              connections: user.getConnections(),
              tasks: user.getTasks(),
            startingSelection: startingSelection,
          );
        }
    ));
  }

  Widget getButton(String text, Function onPressed) {
    return Padding(
        padding: EdgeInsets.all(16),
        child: OutlinedButton(
          onPressed: () => onPressed(),
          child: Text(text),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    var connections = user.getConnections();
    return Material(child: Scaffold(body: Center(child: connections.isEmpty
        ? ConnectionSetup(user: user)
        : Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          getButton('View Tasks', () => pushTaskView(context, user)),
          getButton('Add Connection', () => pushNewConnection(context, user))
        ]
    ))));
  }
}
