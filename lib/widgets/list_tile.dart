import 'package:flutter/material.dart';

class MyListTile extends StatelessWidget {
  const MyListTile({
    super.key,
    this.leading,
    this.trailing,
    required this.text,
    this.onTap,
  });
  final Widget? leading;
  final Widget? trailing;
  final String text;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
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
            leading ?? const SizedBox(),
            Expanded(
              child: Text(
                text,
                style: TextStyle(color: Colors.white),
              ),
            ),
            trailing ?? const SizedBox(),
          ],
        ),
      ),
    );
  }
}
