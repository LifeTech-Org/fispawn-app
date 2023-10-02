import 'package:fispawn/widgets/dialog.dart';
import 'package:flutter/material.dart';

typedef FutureFunction = Future<void> Function();

class AsyncButtonWithDialog extends StatelessWidget {
  const AsyncButtonWithDialog({
    super.key,
    required this.isDanger,
    required this.text,
    required this.action,
    required this.dialogContent,
    required this.dialogActionText,
    required this.dialogActionSuccessText,
    required this.dialogActionErrorText,
  });
  final bool isDanger;
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
        height: 40,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                width: 0.5,
                color: isDanger ? Colors.red.shade800 : Colors.green.shade800),
            color: isDanger ? Colors.red.shade200 : Colors.green.shade200),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isDanger ? Colors.red.shade900 : Colors.green.shade900),
          ),
        ),
      ),
    );
  }
}
