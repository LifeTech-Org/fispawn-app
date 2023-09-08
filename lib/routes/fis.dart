import 'dart:convert';
import 'package:fispawn/models/fis.dart';
import 'package:fispawn/routes/live.dart';
import 'package:flutter/material.dart';
import 'package:fispawn/interface/server.dart';
import 'package:fispawn/widgets/scaffold.dart';
import 'package:fispawn/pages/ended.dart';
import 'package:fispawn/pages/cancelled.dart';
import 'package:fispawn/pages/join.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:fispawn/pages/waiting.dart';
import 'package:web_socket_channel/io.dart';

class MyFIS extends StatefulWidget {
  const MyFIS({super.key, required this.fisid});
  final String fisid;
  @override
  State<MyFIS> createState() => _MyFISState();
}

class _MyFISState extends State<MyFIS> {
  final server = Server();
  final user = FirebaseAuth.instance.currentUser;
  StreamController controller = StreamController();
  late IOWebSocketChannel socket;
  @override
  void initState() {
    user!.getIdToken().then((idToken) {
      if (idToken != null) {
        socket = server
            .socket({"fisid": widget.fisid, "idToken": idToken, "type": "fis"});

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
              body: Center(
                child: CircularProgressIndicator(),
              ),
              appBarTitle: 'Loading fis');
        } else if (snapshot.hasError) {
          return const MyScaffold(
              body: Center(
                child: Text('An Error occured'),
              ),
              appBarTitle: 'Error');
        } else {
          final fis = FIS.fromJSON(json.decode(snapshot.data!)['data']);
          if (fis.status == FISStatus.waiting) {
            return fis.isMember
                ? MyScaffold(
                    appBarTitle: 'Waiting Waitng',
                    body: Waiting(
                      fis: fis,
                    ),
                  )
                : MyScaffold(
                    appBarTitle: 'Join Fispawn',
                    body: Join(
                      authorName: fis.author.displayName,
                      noOfPlayers: fis.players.length,
                    ),
                  );
          } else if (fis.status == FISStatus.ended) {
            return const MyScaffold(body: Ended(), appBarTitle: 'Ended');
          } else if (fis.status == FISStatus.cancelled) {
            return MyScaffold(
                body: Cancelled(authorName: fis.author.displayName),
                appBarTitle: 'Cancelled');
          } else {
            if (fis.isMember) {
              return LiveFIS(
                fis: fis,
              );
            } else {
              return const MyScaffold(
                  body: Ended(), appBarTitle: 'Already started');
            }
          }
        }
      },
    );
  }
}
