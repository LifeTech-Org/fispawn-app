import 'package:fispawn/widgets/button.dart';
import 'package:flutter/material.dart';

class Join extends StatelessWidget {
  const Join({super.key, required this.authorName, required this.noOfPlayers});
  final String authorName;
  final int noOfPlayers;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const SizedBox(
              height: 20,
            ),
            Text(
              'Join $authorName ${noOfPlayers > 0 ? 'and $noOfPlayers other${noOfPlayers == 1 ? '' : 's'} ' : ''} to complete on Fispawn',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Spacer(),
                MyButton(
                    title: 'Join Challenge', function: () {}, isDanger: false),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
