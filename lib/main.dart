import 'package:flutter/material.dart';
import 'package:smart_mirror/core/model/user.dart';
import 'package:smart_mirror/modules/smart_mirror_controller.dart';
import 'package:smart_mirror/theme.dart';

void main() {
  runApp(SmartMirrorApp());
}

class SmartMirrorApp extends StatelessWidget {
  final user = User();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.darkTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => SmartMirrorController(user: user),
        '/tasks': (context) => SmartMirrorController.buildTaskView(user)
      },
    );
  }
}
