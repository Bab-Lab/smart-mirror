import 'package:flutter/material.dart';
import 'package:smart_mirror/core/model/SmartMirror.dart';
import 'package:smart_mirror/core/model/User.dart';
import 'package:smart_mirror/modules/NewUserForm.dart';
import 'package:smart_mirror/modules/TaskViewController.dart';

ThemeData theme = ThemeData(
  primaryColor: Colors.black,
  backgroundColor: Colors.black,
);

class SmartMirrorController extends StatelessWidget {
  final SmartMirror smartMirror;
  static const TaskViewController taskViewController = TaskViewController();

  const SmartMirrorController({Key? key, required this.smartMirror})
      : super(key: key);

  List<Widget> getAvatars(List<Future<User>> users) {
    var avatars = <Widget>[];
    for (int i = 0; i < users.length; i++) {
      var user = users[i];
      avatars.add(FutureBuilder(
          future: user,
          builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
            if (!snapshot.hasData)
              return CircularProgressIndicator();
            else
              return InkWell(
                child: Column(
                  children: [CircleAvatar(), Text(snapshot.data!.name)],
                ),
                onTap: () {},
              );
          }));
    }
    return avatars;
  }

  @override
  Widget build(BuildContext context) {
    var users = smartMirror.getUsers();
    return Material(
        child: users.isEmpty
            ? NewUserForm(smartMirror: this.smartMirror)
            : Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: getAvatars(users))));
  }
}
