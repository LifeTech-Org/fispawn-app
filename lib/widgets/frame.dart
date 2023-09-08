import 'package:flutter/material.dart';

class Frame extends StatelessWidget {
  const Frame({super.key, required this.body});
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      width: double.infinity,
      child: body,
    );
  }
}
