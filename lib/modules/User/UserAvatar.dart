import 'package:flutter/material.dart';
import 'package:smart_mirror/core/model/User.dart';

class UserAvatar extends StatelessWidget {
  final User user;

  const UserAvatar({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [CircleAvatar(), Text(user.name)]);
  }
}
