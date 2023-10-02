import 'dart:convert';

import 'package:fispawn/models/fis.dart';
import 'package:fispawn/pages/lobby.dart';
import 'package:fispawn/pages/play.dart';
import 'package:flutter/material.dart';
import 'package:fispawn/interface/server.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fispawn/widgets/scaffold.dart';
import 'package:web_socket_channel/io.dart';
import 'dart:async';

class LiveFIS extends StatefulWidget {
  const LiveFIS({super.key, required this.fis});
  final FIS fis;
  @override
  State<LiveFIS> createState() => _LiveFISState();
}

class _LiveFISState extends State<LiveFIS> {
  final server = Server();
  final user = FirebaseAuth.instance.currentUser;
  StreamController controller = StreamController();
  late IOWebSocketChannel socket;
  @override
  void initState() {
    user!.getIdToken().then((idToken) {
      if (idToken != null) {
        socket = server.socket(
            {"fisid": widget.fis.id, "idToken": idToken, "type": "session"});
        controller.addStream(socket.stream);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.close();
    socket.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: controller.stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MyScaffold(
              body: Center(child: CircularProgressIndicator()),
              appBarTitle: 'Loading Session');
        } else if (snapshot.hasError) {
          return const MyScaffold(
              body: Center(
                child: Text('Something went wrong'),
              ),
              appBarTitle: 'Error in session');
        } else {
          final session =
              FISSession.fromJSON(json.decode(snapshot.data!)['data']);
          if (session.start) {
            return MyScaffold(
                body: MyPlay(session: session, fis: widget.fis),
                appBarTitle: 'Started FIS');
          } else {
            return MyScaffold(
                body: Center(
                    child: Lobby(
                        isAuthor: widget.fis.isAuthor,
                        fisid: widget.fis.id,
                        players: session.players)),
                appBarTitle: 'Session waitng for');
          }
        }
      },
    );
  }
}
