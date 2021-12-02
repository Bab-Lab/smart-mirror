import 'package:flutter/material.dart';
import 'package:smart_mirror/core/model/SmartMirror.dart';
import 'package:smart_mirror/core/model/User.dart';
import 'package:smart_mirror/core/modules/AuthenticationView/NewUserView.dart';
import 'package:smart_mirror/core/modules/TaskView/TaskViewController.dart';

class SmartMirrorController extends StatelessWidget {
  final SmartMirror smartMirror;
  static const TaskViewController taskViewController = TaskViewController();

  const SmartMirrorController({Key? key, required this.smartMirror}) : super(key: key);

  List<CircleAvatar> getAvatars(List<User> users) {
    List<CircleAvatar> avatars = <CircleAvatar>[];
    for (int i = 0; i < users.length; i++) {
      var user = users[i];
      avatars.add(CircleAvatar(child: Text(user.name)));
    }
    return avatars;
  }

  @override
  Widget build(BuildContext context) {
    var users = smartMirror.getUsers();
    return Center(
      child: users.isEmpty
        ? NewUserView(smartMirror: this.smartMirror)
        : Column(children: getAvatars(users))
    );
  }
}
