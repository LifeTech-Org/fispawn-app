import 'package:fispawn/models/fis.dart';
import 'package:fispawn/widgets/dialog.dart';
import 'package:flutter/material.dart';
import 'package:fispawn/widgets/list_tile.dart';
import "package:fispawn/interface/server.dart";

class Lobby extends StatelessWidget {
  Lobby({
    super.key,
    required this.players,
    required this.isAuthor,
    required this.fisid,
  });
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
                    trailing: player.isMe!
                        ? AsyncActionButton(
                            onTap: () => server.changeReadyStatus(fisid),
                            text: player.ready! ? "Ready" : "Not Ready",
                            successText: "You changed status successfully",
                            errorText: "Couldnt change status")
                        : (isAuthor
                            ? ActionButton(
                                text: 'Remove Player',
                                action: () =>
                                    server.removePlayer(fisid, player.uid),
                                dialogContent:
                                    'Are you sure you want to remove player?',
                                dialogActionText: 'Remove Player',
                                dialogActionSuccessText:
                                    'Player removed successfully',
                                dialogActionErrorText: 'Error removing player',
                              )
                            : null));
              }),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

typedef FutureFunction = Future<void> Function();

class AsyncActionButton extends StatefulWidget {
  const AsyncActionButton({
    super.key,
    required this.onTap,
    required this.text,
    required this.successText,
    required this.errorText,
  });
  final FutureFunction? onTap;
  final String text;
  final String successText;
  final String errorText;
  @override
  State<AsyncActionButton> createState() => _AsyncActionButtonState();
}

class _AsyncActionButtonState extends State<AsyncActionButton> {
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
        if (state == ConnectionState.waiting) {
          changeState(ConnectionState.active);
          widget.onTap!().then((value) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(widget.successText)));
          }).catchError((e) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(widget.errorText)));
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
        child: Center(
          child: state == ConnectionState.waiting
              ? Text(widget.text, style: TextStyle(fontSize: 15))
              : const CircularProgressIndicator(),
        ),
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
    required this.text,
    required this.action,
    required this.dialogContent,
    required this.dialogActionText,
    required this.dialogActionSuccessText,
    required this.dialogActionErrorText,
  });
  final String text;
  final String dialogContent;
  final String dialogActionText;
  final String dialogActionSuccessText;
  final String dialogActionErrorText;
  final FutureFunction action;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => MyDialog(
            content: dialogContent,
            action: action,
            actionText: dialogActionText,
            actionSuccessText: dialogActionSuccessText,
            actionErrorText: dialogActionErrorText,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.orange.shade800,
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
