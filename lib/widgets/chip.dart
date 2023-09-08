import 'package:flutter/material.dart';

class MyChip extends StatelessWidget {
  const MyChip(
      {super.key,
      required this.counts,
      required this.wins,
      required this.photoURL});
  final int counts;
  final int wins;
  final String photoURL;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(photoURL),
        MyChipLabel(color: Colors.orange.shade300, label: wins),
        MyChipLabel(color: Colors.green.shade300, label: counts)
      ],
    );
  }
}

class MyChipLabel extends StatelessWidget {
  const MyChipLabel({super.key, required this.color, required this.label});
  final Color color;
  final int label;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: color),
      child: Text('$label'),
    );
  }
}
