import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:googleapis/calendar/v3.dart';
import "package:googleapis_auth/auth_io.dart";
import 'package:smart_mirror/core/model/connection/iconnection.dart';
import 'package:smart_mirror/core/model/user.dart';
import 'package:url_launcher/url_launcher.dart';

class GoogleConnection extends IConnection {
  late final ClientId _clientID;
  static const _scopes = const [
    CalendarApi.calendarReadonlyScope,
    CalendarApi.calendarEventsReadonlyScope,
    CalendarApi.calendarSettingsReadonlyScope
  ];

  GoogleConnection({required User user})
      : super(user: user, name: 'Google', url: '') {
    if (Platform.isAndroid) {
      _clientID = new ClientId(
          "671736850844-amjsdtn47b101fcn4f3qahg56dgo6egk.apps.googleusercontent.com",
          ""
      );
    } else if (kIsWeb) {
      _clientID = new ClientId(
        "671736850844-7e6gubirl6tlp9rma3sj0hdhqkqo8kc0.apps.googleusercontent.com",
        ""
      );
    } else {
      throw Error();
    }
  }

  void prompt(String url) async {
    print("Please go to the following URL and grant access:");
    print("  => $url");
    print("");

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}