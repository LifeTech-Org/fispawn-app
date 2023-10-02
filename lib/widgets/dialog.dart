import 'package:fispawn/widgets/snackbar.dart';
import 'package:flutter/material.dart';

typedef FutureFunction = Future<void> Function();

class MyDialog extends StatefulWidget {
  const MyDialog({
    super.key,
    required this.content,
    required this.action,
    required this.actionText,
    required this.actionSuccessText,
    required this.actionErrorText,
  });
  final String content;
  final FutureFunction action;
  final String actionText;
  final String actionSuccessText;
  final String actionErrorText;
  @override
  State<MyDialog> createState() => _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {
  ConnectionState state = ConnectionState.waiting;
  void changeState(ConnectionState newState) {
    setState(() {
      state = newState;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text(widget.content),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Go back')),
        state == ConnectionState.waiting
            ? TextButton(
                onPressed: () {
                  changeState(ConnectionState.active);
                  widget.action().then((value) {
                    showMySnackBar(context, widget.actionSuccessText);
                    changeState(ConnectionState.waiting);
                  }).catchError((e) {
                    showMySnackBar(context, widget.actionErrorText);
                    changeState(ConnectionState.waiting);
                  });
                },
                child: Text(widget.actionText))
            : const CircularProgressIndicator()
      ],
    );
  }
}
