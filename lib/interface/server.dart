import 'package:fispawn/models/category.dart';
import 'package:fispawn/models/fis.dart';
import 'package:fispawn/models/server.dart';
// import 'package:fispawn/models/test-server.dart';
import 'package:universal_html/html.dart';

abstract class Server {
  factory Server() => ServerRepo();

  Future<List<Category>> getCategories();
  Future<FIS> getFIS();
  Future<String> createNewFIS(String category);
  Future<EventSource> connectToEventSouce(
      {required String uri, Map<String, String> queries});
}
