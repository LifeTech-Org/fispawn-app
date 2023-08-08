import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fispawn/interface/server.dart';
import 'package:fispawn/models/fis.dart';
import 'package:universal_html/html.dart' as html;

class LiveFIS extends StatefulWidget {
  const LiveFIS({super.key});

  @override
  State<LiveFIS> createState() => _LiveFISState();
}

class _LiveFISState extends State<LiveFIS> {
  StreamController<FISSession> sseStreamController = StreamController();

  html.EventSource? eventSource;
  final server = Server();

  void connectToSSE() async {
    try {
      eventSource = await server
          .connectToEventSouce(uri: 'session', queries: {"fisid": "sduhuf"});

      eventSource!.onMessage.listen((event) {
        print("Session received message");
        sseStreamController.add(FISSession.fromJSON(json.decode(event.data!)));
      });
    } catch (e) {
      print(e);
      // sseStreamController.addError(Error());
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
    print("session ended");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: sseStreamController.stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: Text('Waiting for data'));
        } else if (snapshot.hasError) {
          return const Center(
            child: Text('Something went wrong'),
          );
        } else {
          return const Center(child: Text('Hmmm'));
        }
      },
    );
  }
}
