import 'package:fispawn/models/fis.dart';
import 'package:flutter/material.dart';
import 'package:fispawn/widgets/list_tile.dart';
import "package:fispawn/interface/server.dart";

class Lobby extends StatelessWidget {
  Lobby(
      {super.key,
      required this.players,
      required this.isAuthor,
      required this.fisid});
  final List<Player> players;
  final bool isAuthor;
  final _controller = ScrollController();
  final server = Server();
  final String fisid;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: ListView(
        controller: _controller,
        children: [
          const SizedBox(height: 20),
          Container(
            child: Text(
              'Waiting for ${players.where((player) => !player.ready!).length} participants',
              style: TextStyle(fontSize: 25, color: Colors.white),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ListView.builder(
              shrinkWrap: true,
              itemCount: players.length,
              itemBuilder: (context, index) {
                final player = players.elementAt(index);
                return MyListTile(
                    text: player.displayName,
                    trailing: ReadyButton(
                      onTap: player.isMe!
                          ? () => server.changeReadyStatus(fisid)
                          : null,
                    ));
              }),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

typedef FutureFunction = Future<void> Function();

class ReadyButton extends StatefulWidget {
  const ReadyButton({
    super.key,
    required this.onTap,
  });
  final FutureFunction? onTap;
  @override
  State<ReadyButton> createState() => _ReadyButtonState();
}

class _ReadyButtonState extends State<ReadyButton> {
  ConnectionState state = ConnectionState.waiting;
  void changeState(ConnectionState newState) {
    setState(() {
      state = newState;
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (widget.onTap != null) {
          widget.onTap!().then((value) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('You changed to ready')));
          }).catchError((e) {
            changeState(ConnectionState.waiting);
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.orange.shade800,
        ),
        child: const Center(
          child: Text('Ready', style: TextStyle(fontSize: 15)),
        ),
      ),
    );
  }
}
