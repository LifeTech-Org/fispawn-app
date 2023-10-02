import 'package:fispawn/models/category.dart';
import 'package:fispawn/models/fis.dart';
import 'package:fispawn/models/server.dart';
// import 'package:fispawn/models/test-server.dart';
import 'package:universal_html/html.dart';
import 'package:web_socket_channel/io.dart';

abstract class Server {
  factory Server() => ServerRepo();
  Future<String?> getIdToken();
  IOWebSocketChannel socket(Map<String, String>? queries);
  Future<EventSource> connectToEventSouce(
      {required String uri, Map<String, String> queries});
  Future<List<Category>> getCategories();
  Future<FIS> getFIS();
  Future<String> createNewFIS(String category);
  Future<void> startNewSession(String fisid);
  Future<void> joinFIS(String fisid);
  Future<void> addSpawn(String fisid, String spawn);
  Future<void> changeStatus(String fisid, FISStatus status);
  Future<void> changeReadyStatus(String fisid);
  Future<void> removePlayer(String fisid, String uid);
  Future<void> leaveFIS(String fisid);
}
