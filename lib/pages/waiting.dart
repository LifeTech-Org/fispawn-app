import 'package:fispawn/widgets/buttons/async_button_dialog.dart';
import 'package:flutter/material.dart';
import 'package:fispawn/widgets/list_tile.dart';
import 'package:fispawn/models/fis.dart';
import 'package:fispawn/widgets/buttons/async_button_no_dialog.dart';
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
            ? AsyncButtonWithDialog(
                isDanger: false,
                text: 'Start Fispawn',
                action: () => server.startNewSession(fis.id),
                dialogContent:
                    'Do you want to start? People wont be able to join again.',
                dialogActionText: 'Start now',
                dialogActionSuccessText: 'Fispawn started successfully',
                dialogActionErrorText: 'Couldnt start',
              )
            : const SizedBox()
      ],
    );
  }
}
