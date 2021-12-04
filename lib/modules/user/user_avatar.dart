import 'package:flutter/material.dart';
import 'package:smart_mirror/core/model/user.dart';

class UserAvatar extends StatelessWidget {
  final User user;

  const UserAvatar({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      CircleAvatar(
          maxRadius: 64,
          backgroundImage: NetworkImage(
              'https://ui-avatars.com/api/'
                  '?background=000000&color=fff&size=128'
                  '&name='+ user.name.split(' ').join('+'),
            scale: 1
          ),
      ),
      Container(
          padding: EdgeInsets.all(8.0),
          child: Text(user.name, style: TextStyle(fontSize: 24)))
    ]);
  }
}
