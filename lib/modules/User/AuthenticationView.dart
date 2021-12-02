import 'package:flutter/material.dart';
import 'package:smart_mirror/core/model/User.dart';
import 'package:smart_mirror/modules/User/UserAvatar.dart';

class AuthenticationView extends StatefulWidget {
  final User user;

  const AuthenticationView({Key? key, required this.user}) : super(key: key);

  @override
  State<AuthenticationView> createState() => _AuthenticationViewState();
}

class _AuthenticationViewState extends State<AuthenticationView> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [UserAvatar(user: widget.user)]));
  }
}
