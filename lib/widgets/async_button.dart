import 'package:flutter/material.dart';
import 'package:fispawn/interface/server.dart';

typedef FutureFunction = Future<void> Function();

class AsyncButton extends StatefulWidget {
  const AsyncButton({
    super.key,
    required this.action,
    this.callback,
    required this.title,
    required this.isDanger,
  });
  final FutureFunction action;
  final Function? callback;
  final String title;
  final bool isDanger;
  @override
  State<AsyncButton> createState() => _AsyncButtonState();
}

class _AsyncButtonState extends State<AsyncButton> {
  ConnectionState state = ConnectionState.waiting;
  final Server server = Server();
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
          widget.action().then((value) {
            print("done");
            changeState(ConnectionState.waiting);
            if (widget.callback != null) {
              widget.callback!();
            }
          }).catchError((e) {
            changeState(ConnectionState.waiting);
          });
        }
      },
      child: Container(
        height: 40,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                width: 0.5,
                color: widget.isDanger
                    ? Colors.red.shade800
                    : Colors.green.shade800),
            color:
                widget.isDanger ? Colors.red.shade200 : Colors.green.shade200),
        child: Center(
          child: state == ConnectionState.waiting
              ? Text(
                  widget.title,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: widget.isDanger
                          ? Colors.red.shade900
                          : Colors.green.shade900),
                )
              : CircularProgressIndicator(),
        ),
      ),
    );
  }
}
