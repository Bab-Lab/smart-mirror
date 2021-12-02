import 'dart:async';

import 'package:flutter/material.dart';
import 'package:smart_mirror/core/model/SmartMirror.dart';
import 'package:smart_mirror/core/model/User.dart';

class NewUserForm extends StatefulWidget {
  final SmartMirror smartMirror;

  const NewUserForm({Key? key, required this.smartMirror}) : super(key: key);

  @override
  State<NewUserForm> createState() => _NewUserFormState();
}

class _NewUserFormState extends State<NewUserForm> {
  final nameController = TextEditingController();
  final passController = TextEditingController();
  final verifyController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    passController.dispose();
    verifyController.dispose();
    super.dispose();
  }

  List<int>? tryConvert(String input) {
    var output = <int>[];
    for (var char in input.characters) {
      var maybeInt = int.tryParse(char);
      if (maybeInt == null) return null;
      output.add(maybeInt);
    }
    return output;
  }

  List<String> tryMakeNewUser() {
    var err = <String>[];
    if (nameController.text.length == 0) {
      err.add("Name is a required field");
    }

    var passcode = tryConvert(passController.text);
    if (passcode != null) {
      if (passController.text.length < 3) {
        err.add("Passcode must be at least of length 3");
      }
      if (passController.text != verifyController.text) {
        err.add("Passcodes do not match");
      }
    } else {
      err.add("Passcode must be all numbers");
    }

    if (err.isNotEmpty) return err;

    var nonce = User.getNonce();
    var completer = Completer<User>();
    User.getKeyBytes(passcode!, nonce).then((passhash) => completer.complete(
        User(
            smartMirror: this.widget.smartMirror,
            name: nameController.text,
            passhash: passhash,
            nonce: nonce)));
    this.widget.smartMirror.addUser(completer.future);
    return err;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
          TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name')),
          TextField(
              controller: passController,
              keyboardType: TextInputType.number,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Passcode')),
          TextField(
              controller: verifyController,
              keyboardType: TextInputType.number,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Verify Passcode')),
          TextButton(
              child: const Text("Create New User"),
              onPressed: () {
                var makeUserResult = tryMakeNewUser();
                if (makeUserResult.isEmpty)
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/', (route) => false);
                else
                  showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                            title: const Text("Could not Create User"),
                            content: Text(makeUserResult.join("\n\n")),
                            actions: <Widget>[
                              TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("OK"))
                            ],
                          ));
              })
        ]));
  }
}
