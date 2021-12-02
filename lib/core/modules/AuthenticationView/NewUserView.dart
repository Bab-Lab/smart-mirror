import 'package:flutter/material.dart';
import 'package:smart_mirror/core/model/SmartMirror.dart';
import 'package:smart_mirror/core/model/User.dart';

class NewUserView extends StatelessWidget {
  final SmartMirror smartMirror;

  const NewUserView({Key? key, required this.smartMirror}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(onPressed: () {
      var user = User(smartMirror: this.smartMirror, name: "New User", passcode: "passcode");
      smartMirror.addUser(user);
    }, child: Text("New User"));
  }
}