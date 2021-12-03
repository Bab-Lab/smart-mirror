import 'package:flutter/material.dart';
import 'package:smart_mirror/core/model/smart_mirror.dart';
import 'package:smart_mirror/modules/smart_mirror_controller.dart';

void main() {
  runApp(SmartMirrorApp());
}

class SmartMirrorApp extends StatelessWidget {
  final smartMirror = SmartMirror();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: theme,
      initialRoute: '/',
      routes: {
        '/': (context) => SmartMirrorController(smartMirror: smartMirror),
      },
    );
  }
}
