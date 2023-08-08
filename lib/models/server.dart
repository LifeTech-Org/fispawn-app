import 'dart:convert';

import 'package:fispawn/interface/server.dart';
import 'package:fispawn/models/category.dart';
import 'package:fispawn/models/fis.dart';
import 'package:http/http.dart' as http;
import 'package:universal_html/html.dart';

class ServerRepo implements Server {
  static const api = 'https://fispawn-server-rithoimkwa-uc.a.run.app';
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
    await Future.delayed(Duration(seconds: 2));
    return "fisid";
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
}
