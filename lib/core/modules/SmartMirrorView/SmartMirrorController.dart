import 'package:flutter/material.dart';
import 'package:smart_mirror/core/model/SmartMirror.dart';
import 'package:smart_mirror/core/model/User.dart';
import 'package:smart_mirror/core/modules/AuthenticationView/NewUserView.dart';
import 'package:smart_mirror/core/modules/TaskView/TaskViewController.dart';

ThemeData theme = ThemeData(
  primaryColor: Colors.black,
  backgroundColor: Colors.black,
);

class SmartMirrorController extends StatelessWidget {
  final SmartMirror smartMirror;
  static const TaskViewController taskViewController = TaskViewController();

  const SmartMirrorController({Key? key, required this.smartMirror}) : super(key: key);

  List<InkWell> getAvatars(List<User> users) {
    List<InkWell> avatars = <InkWell>[];
    for (int i = 0; i < users.length; i++) {
      var user = users[i];
      avatars.add(InkWell(
        child: Column(
          children: [
            CircleAvatar(),
            Text(user.name)
          ],
        ),
        onTap: () {},
      ));
    }
    return avatars;
  }

  @override
  Widget build(BuildContext context) {
    var users = smartMirror.getUsers();
    return MaterialApp(
        title: 'Flutter Demo',
        theme: theme,
        home: Material(child: Center(
            child: users.isEmpty
                ? NewUserView(smartMirror: this.smartMirror)
                : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: getAvatars(users)
            )
        ))
    );
  }
}
