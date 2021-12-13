import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart' as googleAPI;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_mirror/core/model/connection/iconnection.dart';
import 'package:smart_mirror/core/model/task.dart';
import 'package:smart_mirror/core/model/user.dart';

class GoogleConnection extends IConnection {
  static const hasConnectionKey = 'hasGoogle';
  static const _scopes = [
    googleAPI.CalendarApi.calendarReadonlyScope,
    googleAPI.CalendarApi.calendarEventsReadonlyScope
  ];

  static final _googleSignIn  = GoogleSignIn(
    clientId: "671736850844-0obaulp1qpue0h8oh673meo5rci1b9a1.apps.googleusercontent.com",
    scopes: _scopes,
  );

  GoogleSignInAccount? _googleUser;

  GoogleConnection({required User user})
      : super(user: user, name: 'Google') {
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      _googleUser = account;
    });
    _googleSignIn.signInSilently();
  }

  Future<Map<String, String>?> getCalendars() async {
    var httpClient = (await _googleSignIn.authenticatedClient())!;
    var calAPI = googleAPI.CalendarApi(httpClient);

    Map<String, String> calendars = {};
    String? pageToken;
    do {
      var calendarList = await calAPI.calendarList.list(pageToken: pageToken);
      calendars.addEntries(calendarList.items!
          .map((e) => MapEntry(e.id!, e.summary!)));
      pageToken = calendarList.nextPageToken;
    } while (pageToken != null);
    print('Found the following calendars ${calendars.values.toList()}');
    return calendars;
  }

  @override
  Future<Map<String, Task>?> getTasks() async {
    var calendars = await getCalendars();
    if (calendars == null) return null;

    Map<String, Task> tasks = {};
    for (var calendarId in calendars.keys) {
      var name = calendars[calendarId];
      print('Pulling events from $name');

      var httpClient = (await _googleSignIn.authenticatedClient())!;
      var calAPI = googleAPI.CalendarApi(httpClient);

      String? pageToken;
      do {
        var events = await calAPI.events.list(
            calendarId, pageToken: pageToken, timeMin: DateTime.now().toUtc());
        if (events.items == null) continue;
        events.items!.removeWhere((element) => element.status == 'cancelled');
        tasks.addEntries(events.items!.map((e) {
          var task = Task(
              uuid: '${this.name}-${e.id!}', name: e.summary!,
              description: e.description, connection: this,
              dateTime: e.start!.dateTime ?? e.start!.date!,
              endDateTime: e.end!.dateTime ?? e.end!.date);
          return MapEntry(task.uuid, task);
        }));
      } while(pageToken != null);
    }
    return tasks;
  }

  @override
  Future<bool> connect() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      await _googleSignIn.signIn();
      prefs.setBool(hasConnectionKey, true);
      return true;
    } catch (error) {
      print(error);
      prefs.setBool(hasConnectionKey, false);
      return false;
    }
  }

  @override
  Future<void> disconnect() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await _googleSignIn.signOut();
    prefs.setBool(hasConnectionKey, false);
  }
}