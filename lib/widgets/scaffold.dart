import 'package:flutter/material.dart';

class MyScaffold extends StatelessWidget {
  const MyScaffold({super.key, required this.widget});
  final Widget widget;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget,
    );
  }
}
