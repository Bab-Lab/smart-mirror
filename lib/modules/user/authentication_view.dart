import 'dart:async';

import 'package:flutter/material.dart';
import 'package:smart_mirror/core/model/security.dart';
import 'package:smart_mirror/core/model/user.dart';
import 'package:smart_mirror/modules/User/user_avatar.dart';
import 'package:smart_mirror/modules/User/user_form_padding.dart';
import 'package:smart_mirror/modules/connection/connection_setup.dart';

class AuthenticationView extends StatefulWidget {
  final User user;

  const AuthenticationView({Key? key, required this.user}) : super(key: key);

  @override
  State<AuthenticationView> createState() => _AuthenticationViewState();
}

class _AuthenticationViewState extends State<AuthenticationView> {
  final passController = TextEditingController();

  @override
  void dispose() {
    passController.dispose();
    super.dispose();
  }

  Future<List<String>> tryValidate() async {
    var err = <String>[];

    var passcode = Secure.tryConvert(passController.text);
    if (passcode != null) {
      if (passController.text.length < 3) {
        err.add("Passcode must be at least of length 3");
      }
    } else {
      err.add("Passcode must be all numbers");
    }

    if (err.isNotEmpty) return err;

    if (!await this
        .widget
        .user
        .smartMirror
        .tryActivateUser(widget.user, passcode!)) {
      err.add("Passcode is incorrect");
    }
    return err;
  }

  void showAuthDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(
              margin: EdgeInsets.only(left: 7),
              child: Text("Authenticating...")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var submitDialog = () {
      showAuthDialog(context);
      tryValidate().then((validateResult) {
        Navigator.pop(context);
        if (validateResult.isNotEmpty)
          showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text("Could not Authenticate"),
                content: Text(validateResult.join("\n\n")),
                actions: <Widget>[
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("OK"))
                ],
              ));
        else {
          Navigator.pop(context);
          if (widget.user.getConnections().isEmpty)
            Navigator.push(context,
                MaterialPageRoute(
                    builder: (context) =>
                        Material(
                            child: ConnectionSetup(user: widget.user)
                        )
                )
            );
        }
      });
    };
    return UserFormPadding(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(flex: 4, child: UserAvatar(user: widget.user)),
          Expanded(
              flex: 2,
              child: TextField(
                controller: passController,
                keyboardType: TextInputType.number,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Passcode'),
                onSubmitted: (value) => submitDialog(),
              )),
          Expanded(
              flex: 2,
              child: TextButton(
                child: const Text("Submit"),
                onPressed: submitDialog,
              ))
        ]
    ));
  }
}
