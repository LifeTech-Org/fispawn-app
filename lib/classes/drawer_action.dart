import 'package:flutter/material.dart';

class DrawerAction {
  DrawerAction({required this.title, required this.icon, required this.action});
  String title;
  IconData icon;
  Function action;
}
