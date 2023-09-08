import 'package:flutter/material.dart';
import 'package:fispawn/widgets/list_tile.dart';
import 'package:fispawn/models/fis.dart';
import 'package:fispawn/widgets/async_button.dart';
import "package:fispawn/interface/server.dart";

class Waiting extends StatelessWidget {
  Waiting({super.key, required this.fis});
  final FIS fis;
  final Server server = Server();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(child: Text('Lobby, waiting for participants')),
        const SizedBox(height: 20),
        ListView.builder(
          itemCount: fis.players.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return MyListTile(text: fis.players.elementAt(index).displayName);
          },
        ),
        fis.isAuthor
            ? AsyncButton(
                title: 'Start',
                isDanger: false,
                action: () => server.addNewSession(fis.id))
            : const SizedBox()
      ],
    );
  }
}
