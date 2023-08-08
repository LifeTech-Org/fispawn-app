import 'package:flutter/material.dart';

class Frame extends StatelessWidget {
  const Frame({
    super.key,
    required this.body,
    required this.appBarTitle,
  });
  final Widget body;
  final String appBarTitle;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.navigate_before_rounded)),
      ),
      body: body,
    );
  }
}
