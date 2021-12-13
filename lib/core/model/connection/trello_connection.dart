import 'dart:convert';

import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_mirror/core/model/connection/iconnection.dart';
import 'package:smart_mirror/core/model/task.dart';
import 'package:smart_mirror/core/model/user.dart';
class TrelloConnection extends IConnection {
  static const hasConnectionKey = 'hasTrello';
  static const _apiKey = 'key=7bb05e73806a742e9b71975e59ead2f9';
  String? _apiToken;

  static const _baseUrl = 'https://trello.com/1';
  static const _apiUrl = '$_baseUrl/authorize'
      '?expiration=never&name=smart-mirror&scope=read&response_type=fragment'
      '&$_apiKey&return_url=http://localhost:8080/auth.html';

  TrelloConnection({required User user}) : super(user: user, name: 'Trello');



  @override
  Future<bool> connect() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _apiToken = prefs.getString('Trello');
    if (_apiToken == null) {
      final result = await FlutterWebAuth.authenticate(
          url: _apiUrl, callbackUrlScheme: "com.lab.bab.smart_mirror");
      _apiToken = Uri.parse(result).fragment;
    }
    if (_apiToken == null) return false;
    prefs.setString('Trello', _apiToken!);
    prefs.setBool(hasConnectionKey, true);
    return true;
  }

  @override
  Future<void> disconnect() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(hasConnectionKey, false);
  }

  String getParams() => '?$_apiKey&$_apiToken';

  Future<Map<String, String>?> getBoards() async {
    var url = Uri.parse('$_baseUrl/members/me/boards${getParams()}');
    var response = await http.get(url);

    if (response.statusCode != 200) return null;

    var body = json.decode(response.body);

    Map<String, String> calendars = Map.fromIterable(body, key: (e) => e['id'], value: (e) => e['name']);
    print('Found the following calendars ${calendars.values.toList()}');

    return calendars;
  }

  @override
  Future<Map<String, Task>?> getTasks() async {
    var boards = await getBoards();
    if (boards == null) return null;

    Map<String, Task> tasks = {};
    for (var boardId in boards.keys) {
      var name = boards[boardId];
      print('Pulling events from $name');

      var url = Uri.parse('$_baseUrl/boards/$boardId/cards${getParams()}');
      var response = await http.get(url);

      if (response.statusCode != 200) return null;

      var body = json.decode(response.body);

      for (var entry in body) {
        var lastActivity = DateTime.parse(entry['dateLastActivity']);
        var due = entry['due'];
        var task = Task(
            uuid: entry['id'],
            name: entry['name'],
            description: entry['desc'],
            connection: this,
            dateTime: due != null ? DateTime.parse(due)
                : DateTime(lastActivity.year + 1, lastActivity.month, lastActivity.day)
        );
        tasks[task.uuid] = task;
      }
    }
    return tasks;
  }
}