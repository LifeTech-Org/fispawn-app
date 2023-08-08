import 'package:flutter/material.dart';

class Waiting extends StatelessWidget {
  Waiting({super.key});
  final _controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: ListView(
        controller: _controller,
        children: [
          const SizedBox(height: 20),
          Container(
            child: Text(
              'Waiting for 10 participants',
              style: TextStyle(fontSize: 25, color: Colors.white),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ...List.generate(20, (index) => Player()).toList(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class Player extends StatelessWidget {
  const Player({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Expanded(
            child: Text(
              'Join Ayetigbo Samuel',
              style: TextStyle(color: Colors.white),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.orange.shade800,
            ),
            child: Center(
              child: Text('Ready', style: TextStyle(fontSize: 15)),
            ),
          ),
        ],
      ),
    );
  }
}
