import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fispawn/interface/server.dart';
import 'package:fispawn/models/category.dart';
import 'package:fispawn/models/fis.dart';
import 'package:http/http.dart' as http;
import 'package:universal_html/html.dart';
import 'package:web_socket_channel/io.dart';

class ServerRepo implements Server {
  static const isLocalhost = true;
  static const api = isLocalhost
      ? "http://192.168.41.206:3001"
      : 'https://fispawn-server-rithoimkwa-uc.a.run.app';

  // @override
  // Future<List<Category>> getCategories() async {
  //   try {
  //     final response = await http.get(Uri.parse(''));
  //     if (response.statusCode == 200) {
  //       final List<Map<String, dynamic>> data = json.decode(response.body);
  //       return data.map((category) => Category.fromJSON(category)).toList();
  //     } else {
  //       return Future.error('Error 3');
  //     }
  //   } catch (e) {
  //     return Future.error('Error 3');
  //   }
  // }

  @override
  Future<String?> getIdToken() async {
    final user = FirebaseAuth.instance.currentUser;
    final idToken = await user?.getIdToken();
    return idToken;
  }

  @override
  Future<List<Category>> getCategories() async {
    await Future.delayed(Duration(seconds: 2));
    return List.generate(
            10,
            (index) => Category.fromJSON(
                {'name': "Agriculture", 'imgURL': "", 'noOfParticipants': 40}))
        .toList();
  }

  @override
  Future<FIS> getFIS() async {
    try {
      final response = await http.get(Uri.parse(''));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return FIS.fromJSON(data);
      } else {
        return Future.error('Error 3');
      }
    } catch (e) {
      return Future.error('Error 3');
    }
  }

  @override
  Future<String> createNewFIS(String category) async {
    try {
      final idToken = await getIdToken();

      if (idToken == null) return Future.error('User Error');
      final response = await http.post(Uri.parse('$api/newfis'),
          headers: {
            "Authorization": 'Bearer $idToken',
            'Content-Type': 'application/json'
          },
          body: jsonEncode({"category": category}));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print(data['fisid']);
        return data['fisid'];
      } else {
        return Future.error('Error from server');
      }
    } catch (e) {
      return Future.error('Error with your request');
    }
  }
  // Future<void> dd(String fisid) async {
  //   try {
  //     final idToken = await getIdToken();

  //     if (idToken == null) return Future.error('User Error');
  //     await http.post(Uri.parse('$api/'),
  //         body: jsonEncode({"fisid": fisid}),
  //         headers: {
  //   "Authorization": 'Bearer $idToken',
  //   'Content-Type': 'application/json'
  // };
  //     return;
  //   } catch (e) {
  //     return Future.error("Bad Request");
  //   }
  // }

  @override
  Future<void> addNewSession(String fisid) async {
    try {
      final idToken = await getIdToken();
      if (idToken == null) return Future.error('User Error');
      await http.post(Uri.parse('$api/newsession'),
          body: jsonEncode({"fisid": fisid}),
          headers: {
            "Authorization": 'Bearer $idToken',
            'Content-Type': 'application/json'
          });
      return;
    } catch (e) {
      return Future.error("Bad Request");
    }
  }

  @override
  Future<void> joinFIS(String fisid) async {
    try {
      final idToken = await getIdToken();
      if (idToken == null) return Future.error('User Error');
      await http.put(Uri.parse('$api/joinfis'),
          body: jsonEncode({"fisid": fisid}),
          headers: {
            "Authorization": 'Bearer $idToken',
            'Content-Type': 'application/json'
          });
      return;
    } catch (e) {
      return Future.error("Bad Request");
    }
  }

  @override
  Future<void> addSpawn(String fisid, String spawn) async {
    try {
      final idToken = await getIdToken();

      if (idToken == null) return Future.error('User Error');
      await http.put(Uri.parse('$api/spawn'),
          body: jsonEncode({"fisid": fisid, "spawn": spawn}),
          headers: {
            "Authorization": 'Bearer $idToken',
            'Content-Type': 'application/json'
          });
      return;
    } catch (e) {
      return Future.error("Bad Request");
    }
  }

  @override
  Future<void> changeStatus(String fisid, FISStatus status) async {
    try {
      final idToken = await getIdToken();

      if (idToken == null) return Future.error('User Error');
      await http.put(Uri.parse('$api/fisstatus'),
          body: jsonEncode({"fisid": fisid, "status": status}),
          headers: {
            "Authorization": 'Bearer $idToken',
            'Content-Type': 'application/json'
          });
      return;
    } catch (e) {
      return Future.error("Bad Request");
    }
  }

  @override
  Future<void> changeReadyStatus(String fisid) async {
    try {
      final idToken = await getIdToken();

      if (idToken == null) return Future.error('User Error');
      await http.put(Uri.parse('$api/readystatus'),
          body: jsonEncode({"fisid": fisid}),
          headers: {
            "Authorization": 'Bearer $idToken',
            'Content-Type': 'application/json'
          });
      return;
    } catch (e) {
      return Future.error("Bad Request");
    }
  }

  @override
  Future<void> removePlayer(String fisid, String uid) async {
    try {
      final idToken = await getIdToken();

      if (idToken == null) return Future.error('User Error');
      await http.put(Uri.parse('$api/removeplayer'),
          body: jsonEncode({"fisid": fisid, "uid": uid}),
          headers: {
            "Authorization": 'Bearer $idToken',
            'Content-Type': 'application/json'
          });
      return;
    } catch (e) {
      return Future.error("Bad Request");
    }
  }

  @override
  Future<void> leaveFIS(String fisid) async {
    try {
      final idToken = await getIdToken();

      if (idToken == null) return Future.error('User Error');
      await http.put(Uri.parse('$api/leavefis'),
          body: jsonEncode({"fisid": fisid}),
          headers: {
            "Authorization": 'Bearer $idToken',
            'Content-Type': 'application/json'
          });
      return;
    } catch (e) {
      return Future.error("Bad Request");
    }
  }

  String parseQueries(Map<String, String> queries) {
    String result = '';
    queries.forEach((key, value) {
      result += '$key=$value&';
    });
    return result;
  }

  @override
  Future<EventSource> connectToEventSouce(
      {required String uri, Map<String, String>? queries}) async {
    String parsedQueries = queries == null ? "" : parseQueries(queries);
    return EventSource(
      Uri.parse('$api/$uri?$parsedQueries').toString(),
      withCredentials: true,
    );
  }

  @override
  IOWebSocketChannel socket(Map<String, String>? queries) {
    String parsedQueries = queries == null ? "" : parseQueries(queries);
    return IOWebSocketChannel.connect(
        Uri.parse("ws://192.168.41.206:3001/connect?$parsedQueries"));
  }
}
