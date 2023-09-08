import 'package:flutter/material.dart';

typedef FutureFunction = Future<dynamic?> Function();
class MyButton extends StatelessWidget {
  const MyButton({
    super.key,
    required this.title,
    required this.function,
    required this.isDanger,
  });
  final String title;
  final Function function;
  final bool isDanger;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () => function,
        child: Container(
          height: 40,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  width: 0.5,
                  color:
                      isDanger ? Colors.red.shade800 : Colors.green.shade800),
              color: isDanger ? Colors.red.shade200 : Colors.green.shade200),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color:
                      isDanger ? Colors.red.shade900 : Colors.green.shade900),
            ),
          ),
        ),
      ),
    );
  }
}
