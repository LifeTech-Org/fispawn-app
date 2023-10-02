import 'package:flutter/material.dart';

typedef FutureFunction = Future<dynamic> Function();

class MyListTile extends StatefulWidget {
  const MyListTile({
    super.key,
    this.leading,
    this.trailing,
    required this.text,
    this.function,
    this.successCallBack,
    this.errorMessage,
    this.init,
  });
  final Widget? leading;
  final Widget? trailing;
  final String text;
  final FutureFunction? function;
  final Function(dynamic)? successCallBack;
  final String? errorMessage;
  final VoidCallback? init;

  @override
  State<MyListTile> createState() => _MyListTileState();
}

class _MyListTileState extends State<MyListTile> {
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
        if (widget.function != null) {
          if (widget.init != null) {
            widget.init!();
          }
          changeState(ConnectionState.active);
          widget.function!().then((value) {
            changeState(ConnectionState.waiting);
            if (widget.successCallBack != null) {
              widget.successCallBack!(value);
            }
          }).catchError((e) {
            changeState(ConnectionState.waiting);
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('Something went wrong')));
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.all(10.0),
        margin: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: Colors.grey.shade900,
          border: Border.all(
            color: Colors.grey.shade800,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            widget.leading ?? const SizedBox(),
            Expanded(
              child: Text(
                widget.text,
                style: TextStyle(color: Colors.white),
              ),
            ),
            state == ConnectionState.waiting
                ? (widget.trailing ?? const SizedBox())
                : const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
