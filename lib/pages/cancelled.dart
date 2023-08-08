import 'package:flutter/material.dart';

class Cancelled extends StatelessWidget {
  const Cancelled({super.key, required this.authorName});
  final String authorName;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('$authorName cancelled the game'),
    );
  }
}
