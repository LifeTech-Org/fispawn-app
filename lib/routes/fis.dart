import 'dart:async';
import 'dart:convert';
import 'package:fispawn/models/fis.dart';
import 'package:fispawn/routes/live.dart';
import 'package:flutter/material.dart';
import 'package:fispawn/interface/server.dart';
import 'package:fispawn/widgets/frame.dart';
import 'package:fispawn/pages/ended.dart';
import 'package:fispawn/pages/cancelled.dart';
import 'package:fispawn/pages/join.dart';
import 'package:universal_html/html.dart' as html;

class MyFIS extends StatefulWidget {
  const MyFIS({super.key});

  @override
  State<MyFIS> createState() => _MyFISState();
}

class _MyFISState extends State<MyFIS> {
  StreamController<FIS> sseStreamController = StreamController();
  html.EventSource? eventSource;
  final server = Server();

  void connectToSSE() async {
    int test = 1;
    if (test == 1) {
      eventSource = await server
          .connectToEventSouce(uri: 'getfis', queries: {"fisid": "sdhfjee"});

      eventSource!.onMessage.listen((message) {
        print("FIS received message");
        sseStreamController.add(FIS.fromJSON(json.decode(message.data)));
      });

      eventSource!.onError.listen((event) {
        eventSource?.close();
      });
      test = test + 1;
    }
  }

  @override
  void initState() {
    connectToSSE();
    super.initState();
  }

  @override
  void dispose() {
    eventSource?.close();
    print("fis ended");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: sseStreamController.stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Frame(
              body: Center(
                child: CircularProgressIndicator(),
              ),
              appBarTitle: 'Loading fis');
        } else if (snapshot.hasError) {
          return const Frame(
              body: Center(
                child: Text('An Error occured'),
              ),
              appBarTitle: 'Error');
        } else {
          final fis = snapshot.data!;
          if (fis.status == FISStatus.waiting) {
            return Frame(
              appBarTitle: 'Waiting',
              body: Join(
                authorName: fis.author.displayName,
                noOfPlayers: fis.players.length,
              ),
            );
          }
          if (fis.status == FISStatus.ended) {
            return const Frame(body: Ended(), appBarTitle: 'Ended');
          }
          if (fis.status == FISStatus.cancelled) {
            return Frame(
                body: Cancelled(authorName: fis.author.displayName),
                appBarTitle: 'Cancelled');
          }
          return Frame(body: LiveFIS(), appBarTitle: 'Live');
        }
      },
    );
  }
}
