import 'package:flutter/material.dart';

class PublicWaiting extends StatelessWidget {
  PublicWaiting({super.key});

  final _controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: ListView(
        controller: _controller,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image.asset(name),
                Text(
                  'Agriculture',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Play fispawn with your friends under these category. See how far you are  familiar bla bla bla',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ListView.builder(
              shrinkWrap: true,
              itemCount: 20,
              controller: _controller,
              itemBuilder: (context, index) {
                return Room();
              }),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}

class Room extends StatelessWidget {
  const Room({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.all(10.0),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
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
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2000),
                color: Colors.white,
              ),
              child: Center(
                child: Text('20'),
              ),
            ),
            Icon(
              Icons.navigate_next,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
