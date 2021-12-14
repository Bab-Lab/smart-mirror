import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_mirror/core/model/connection/google_connection.dart';
import 'package:smart_mirror/core/model/connection/trello_connection.dart';
import 'package:smart_mirror/core/model/user.dart';
import 'package:smart_mirror/modules/smart_mirror_controller.dart';
import 'package:smart_mirror/theme.dart';

void main() {
  runApp(
    SplashApp(
      key: UniqueKey(),
      onInitializationComplete: runMainApp,
    ),
  );
}

void runMainApp({required User user}) =>
    runApp(SmartMirrorApp(user: user));

class SmartMirrorApp extends StatelessWidget {
  final user;
  SmartMirrorApp({Key? key, required this.user}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'smart-mirror',
      theme: AppTheme.darkTheme,
      home: SmartMirrorController(user: user),
    );
  }
}

class SplashApp extends StatefulWidget {
  final Function({required User user}) onInitializationComplete;

  const SplashApp({
    Key? key,
    required this.onInitializationComplete,
  }) : super(key: key);

  @override
  _SplashAppState createState() => _SplashAppState();
}

class _SplashAppState extends State<SplashApp> {
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializeAsyncDependencies();
  }

  Future<void> _initializeAsyncDependencies() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var hasGoogle = prefs.getBool(GoogleConnection.hasConnectionKey) ?? false;
    var hasTrello = prefs.getBool(TrelloConnection.hasConnectionKey) ?? false;

    var user = User(hasGoogle: hasGoogle, hasTrello: hasTrello);
    widget.onInitializationComplete(user: user);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'smart-mirror',
      theme: AppTheme.darkTheme,
      home: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_hasError) {
      return Center(
        child: ElevatedButton(
          child: Text('retry'),
          onPressed: () => main(),
        ),
      );
    }
    return Center(child: CircularProgressIndicator());
  }
}
