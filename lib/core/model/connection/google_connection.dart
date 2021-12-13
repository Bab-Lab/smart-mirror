import 'dart:convert' show json;

import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart' as googleAPI;
import "package:http/http.dart" as http;
import 'package:smart_mirror/core/model/connection/iconnection.dart';
import 'package:smart_mirror/core/model/user.dart';

class GoogleConnection extends IConnection {
  static const _scopes = [
    googleAPI.CalendarApi.calendarReadonlyScope,
    googleAPI.CalendarApi.calendarEventsReadonlyScope
  ];

  static final _googleSignIn  = GoogleSignIn(
      clientId: "671736850844-0obaulp1qpue0h8oh673meo5rci1b9a1.apps.googleusercontent.com",
      scopes: _scopes,
  );
  static final identifier = "671736850844-amjsdtn47b101fcn4f3qahg56dgo6egk.apps.googleusercontent.com";
  static final callbackUrlScheme = "com.googleusercontent.apps.671736850844-amjsdtn47b101fcn4f3qahg56dgo6egk";
  static final redirectUrl = Uri.parse(callbackUrlScheme + ':/');

  static final tokenEndpoint = Uri.parse('https://www.googleapis.com/oauth2/v4/token');
  static final authorizationEndpoint = Uri.https('accounts.google.com', '/o/oauth2/v2/auth');

  String? accessToken;
  GoogleSignInAccount? googleUser;

  GoogleConnection({required User user})
      : super(user: user, name: 'Google') {
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      googleUser = account;
    });
    _googleSignIn.signInSilently();
  }

  Future<Map<String, String>?> getCalendars() async {
    final http.Response response = await http.get(
      Uri.parse('https://www.googleapis.com/calendar/v3/users/me/calendarList'),
      headers: await googleUser!.authHeaders,
    );
    if (response.statusCode != 200) {
      print('People API ${response.statusCode} response: ${response.body}');
      return null;
    }
    final Map<String, dynamic> data = json.decode(response.body);
    print(data);
    return Map.fromIterable(data['items'],
        key: (e) => e['id'], value: (e) => e['summary']);
  }


  @override
  Future<bool> connect() async {
    try {
      await _googleSignIn.signIn();
      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }

  @override
  Future<void> disconnect() async {
    await _googleSignIn.signOut();
  }
}