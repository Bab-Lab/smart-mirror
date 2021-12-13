import 'package:flutter/material.dart';
import 'package:smart_mirror/core/model/user.dart';
import 'package:smart_mirror/modules/connection/connection_setup.dart';
import 'package:smart_mirror/modules/task/task_view_controller.dart';

class SmartMirrorController extends StatelessWidget {
  final User user;

  const SmartMirrorController({Key? key, required this.user})
      : super(key: key);

  void pushNewConnection(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Material(
            child: ConnectionSetup(user: user)))
    );
  }

  static Widget buildTaskView(User user) {
    return FutureBuilder<bool>(
        future: user.connectAndLoad(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData) {
            return TasksViewController(tasks: user.getTasks());
          } else return Center(child: CircularProgressIndicator());
        }
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
          ElevatedButton(
              child: Text('View Tasks'),
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Material(
                      child: buildTaskView(user)))
              )
          ),
          ElevatedButton(
              child: Text('Add Connection'),
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Material(
                      child: ConnectionSetup(user: user)))
              )
          )
        ]
    ))));
  }
}
