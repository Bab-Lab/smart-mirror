import 'package:flutter/material.dart';
import 'package:smart_mirror/core/model/SmartMirror.dart';
import 'package:smart_mirror/core/model/User.dart';
import 'package:smart_mirror/core/modules/SmartMirrorView/SmartMirrorController.dart';

class NewUserView extends StatelessWidget {
  final SmartMirror smartMirror;

  const NewUserView({Key? key, required this.smartMirror}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(onPressed: () {
      var nonce = User.getNonce();
      User.getKeyBytes([1, 2, 3, 4], nonce).then((keyBytes) {
        var user = User(
            smartMirror: this.smartMirror, name: "New User",
            passhash: keyBytes, nonce: nonce
        );
        smartMirror.addUser(user);
        runApp(SmartMirrorController(smartMirror: smartMirror));
      });
    }, child: Text("New User"));
  }
}