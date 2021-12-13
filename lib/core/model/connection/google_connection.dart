import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart' as googleAPI;
import 'package:http/http.dart';
import 'package:http/io_client.dart';
import 'package:smart_mirror/core/model/connection/iconnection.dart';
import 'package:smart_mirror/core/model/user.dart';
import 'package:url_launcher/url_launcher.dart';

class GoogleAPIClient extends IOClient {
  Map<String, String> _headers;

  GoogleAPIClient(this._headers) : super();

  @override
  Future<IOStreamedResponse> send(BaseRequest request) =>
      super.send(request..headers.addAll(_headers));

  @override
  Future<Response> head(Uri url, {Map<String, String>? headers}) =>
      super.head(url, headers: headers!..addAll(_headers));
}

class GoogleConnection extends IConnection {
  static const _scopes = [
    googleAPI.CalendarApi.calendarReadonlyScope,
    googleAPI.CalendarApi.calendarEventsReadonlyScope
  ];
  static final _googleSignIn  = GoogleSignIn(
      clientId: "671736850844-amjsdtn47b101fcn4f3qahg56dgo6egk.apps.googleusercontent.com",
      scopes: _scopes
  );
  static final identifier = "671736850844-amjsdtn47b101fcn4f3qahg56dgo6egk.apps.googleusercontent.com";
  static final callbackUrlScheme = "com.googleusercontent.apps.671736850844-amjsdtn47b101fcn4f3qahg56dgo6egk";
  static final redirectUrl = Uri.parse(callbackUrlScheme + ':/');

  static final tokenEndpoint = Uri.parse('https://www.googleapis.com/oauth2/v4/token');
  static final authorizationEndpoint = Uri.https('accounts.google.com', '/o/oauth2/v2/auth');

  String? accessToken;

  GoogleConnection({required User user})
      : super(user: user, name: 'Google');

  Future<void> connect() async {
    final googleUser = await _googleSignIn.signIn();
    final httpClient = GoogleAPIClient(await googleUser!.authHeaders);
    final googleAPI.CalendarApi calendarAPI = googleAPI.CalendarApi(httpClient);
    final googleAPI.Events calEvents = await calendarAPI.events.list("primary");
    final appointments = <googleAPI.Event>[];
    if (calEvents != null && calEvents.items != null) {
      for (int i = 0; i < calEvents.items!.length; i++) {
        final googleAPI.Event event = calEvents.items![i];
        if (event.start == null) {
          continue;
        }
        appointments.add(event);
      }
    }
    print(appointments);
  }

  @override
  Future<void> disconnect() {
    // TODO: implement disconnect
    throw UnimplementedError();
  }

  void prompt(String url) async {

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}