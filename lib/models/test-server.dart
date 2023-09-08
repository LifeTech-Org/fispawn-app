// import 'package:fispawn/interface/server.dart';
// import 'package:fispawn/models/category.dart';
// import 'package:fispawn/models/fis.dart';
// import 'package:universal_html/html.dart';

// class TestServer implements Server {
//   @override
//   Future<FIS> getFIS() async {
//     try {
//       await Future.delayed(Duration(seconds: 1));
//       return FIS.fromJSON({
//         'id': 'fisid',
//         'category': 'Agriculture',
//         'status': 'live',
//         'isAuthor': true,
//         'activeSessionId': 'session id',
//         'author': {'uid': 'player id', 'displayName': 'User Test'},
//         'players': []
//       });
//     } catch (e) {
//       return Future.error('Error 3');
//     }
//   }

//   @override
//   Future<List<Category>> getCategories() async {
//     await Future.delayed(Duration(seconds: 2));
//     return List.generate(
//             10,
//             (index) => Category.fromJSON(
//                 {'name': "Agriculture", 'imgURL': "", 'noOfParticipants': 40}))
//         .toList();
//   }

//   @override
//   Future<String> createNewFIS(String category) async {
//     await Future.delayed(Duration(seconds: 2));
//     // return Future.error("error");
//     return "fis";
//   }

//   String parseQueries(Map<String, String> queries) {
//     String result = '';
//     queries.forEach((key, value) {
//       result += '$key=$value&';
//     });
//     return result;
//   }

//   @override
//   Future<EventSource> connectToEventSouce(
//       {required String uri, Map<String, String>? queries}) async {
//     String parsedQueries = queries == null ? "" : parseQueries(queries);
//     return EventSource(
//       Uri.parse('http://192.168.43.206:3000/$uri?$parsedQueries').toString(),
//     );
//   }
// }
