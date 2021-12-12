import 'package:flutter/material.dart';
import 'package:smart_mirror/core/model/user.dart';
import 'package:smart_mirror/modules/connection/google_signin_button.dart';


class ConnectionSetup extends StatelessWidget {
  final User user;

  ConnectionSetup({Key? key, required this.user}) : super(key: key);

  Widget build(BuildContext context) {
    return Center(child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GoogleSignInButton(user: user)
      ],
    ));
  }
}