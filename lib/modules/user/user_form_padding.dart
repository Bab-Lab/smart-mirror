import 'package:flutter/material.dart';

class UserFormPadding extends StatelessWidget {
  final Widget child;

  const UserFormPadding({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(child: ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 512, maxWidth: 512),
      child: child,
    ));
  }
}
