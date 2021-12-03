import 'package:flutter_test/flutter_test.dart';
import 'package:smart_mirror/main.dart';

void main() {
  testWidgets('App opens smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(SmartMirrorApp());
  });
}
