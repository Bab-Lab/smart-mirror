import 'package:flutter/material.dart';
import 'package:smart_mirror/core/model/user.dart';
import 'package:smart_mirror/modules/connection/google_signin_button.dart';
import 'package:smart_mirror/modules/connection/trello_signin_button.dart';


class ConnectionSetup extends StatelessWidget {
  final User user;

  ConnectionSetup({Key? key, required this.user}) : super(key: key);

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Connect Account')),
        body: Center(child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (!user.hasGoogle()) GoogleSignInButton(user: user),
            if (!user.hasTrello()) TrelloSignInButton(user: user)
          ],
        ))
    );
  }
}