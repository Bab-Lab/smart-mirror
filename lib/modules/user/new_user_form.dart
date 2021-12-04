import 'dart:async';

import 'package:flutter/material.dart';
import 'package:smart_mirror/core/model/smart_mirror.dart';
import 'package:smart_mirror/core/model/user.dart';
import 'package:smart_mirror/modules/User/user_form_padding.dart';

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

  List<String> tryMakeNewUser() {
    var err = <String>[];
    if (nameController.text.length == 0) {
      err.add("Name is a required field");
    }

    var passcode = User.tryConvert(passController.text);
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
    User.getKeyHash(passcode!, nonce).then((passhash) => completer.complete(
        User(
            smartMirror: this.widget.smartMirror,
            name: nameController.text,
            passhash: passhash)));
    this.widget.smartMirror.addUser(completer.future);
    return err;
  }

  @override
  Widget build(BuildContext context) {
    var submitDialog = () {
      var makeUserResult = tryMakeNewUser();
      if (makeUserResult.isEmpty)
        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
      else
        showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text("Could not Create user"),
              content: Text(makeUserResult.join("\n\n")),
              actions: <Widget>[
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("OK"))
              ],
            ));
    };

    var nameFocus = new FocusNode();
    var passFocus = new FocusNode();
    var verifyFocus = new FocusNode();

    return UserFormPadding(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
              flex: 3,
              child: TextField(
                controller: nameController,
                focusNode: nameFocus,
                decoration: const InputDecoration(labelText: 'Name'),
                onSubmitted: (value) => passFocus.requestFocus(),
              )),
          Expanded(
              flex: 3,
              child: TextField(
                controller: passController,
                focusNode: passFocus,
                keyboardType: TextInputType.number,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Passcode'),
                onSubmitted: (value) => verifyFocus.requestFocus(),
              )),
          Expanded(
              flex: 3,
              child: TextField(
                controller: verifyController,
                focusNode: verifyFocus,
                keyboardType: TextInputType.number,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Verify Passcode'),
                onSubmitted: (value) => submitDialog(),
              )),
          Expanded(
              flex: 1,
              child: TextButton(
                child: const Text("Create New user"),
                onPressed: submitDialog,
              ))
        ]));
  }
}
