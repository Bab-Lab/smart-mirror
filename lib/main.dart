import 'package:flutter/material.dart';
import 'package:smart_mirror/core/modules/SmartMirrorView/SmartMirrorController.dart';

import 'package:smart_mirror/core/model/SmartMirror.dart';

ThemeData THEME = ThemeData(
    primaryColor: Colors.black,
    backgroundColor: Colors.black,
);

void main() {
  runApp(SmartMirrorApp());
}

class SmartMirrorApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: THEME,
      home: SmartMirrorController(smartMirror: SmartMirror()),
    );
  }
}
