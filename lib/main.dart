import 'package:flutter/material.dart';
import 'package:smart_mirror/core/modules/SmartMirrorView/SmartMirrorController.dart';

import 'package:smart_mirror/core/model/SmartMirror.dart';

void main() {
  runApp(SmartMirrorApp());
}

class SmartMirrorApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return SmartMirrorController(smartMirror: SmartMirror());;
  }
}
