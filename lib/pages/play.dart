import 'package:fispawn/models/fis.dart';
import 'package:fispawn/pages/lobby.dart';
import 'package:fispawn/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:fispawn/widgets/chip.dart';
import 'package:fispawn/utils/keys.dart';
import "package:fispawn/interface/server.dart";

class MyPlay extends StatelessWidget {
  const MyPlay({super.key, required this.session, required this.fis});
  final FISSession session;
  final FIS fis;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      width: double.infinity,
      child: Column(
        children: [
          ScoreBoard(stats: session.stats, players: session.players),
          PlayColumn(session: session),
          FISActions(fis: fis),
        ],
      ),
    );
  }
}

class ScoreBoard extends StatelessWidget {
  const ScoreBoard({super.key, required this.stats, required this.players});
  final List<Stat> stats;
  final List<Player> players;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: SizedBox(
        height: 50,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: stats.length,
          itemBuilder: ((context, index) {
            final stat = stats.elementAt(index);
            final player =
                players.firstWhere((player) => player.uid == stat.uid);
            return MyChip(
                counts: stat.counts,
                wins: stat.wins,
                photoURL: player.photoURL!);
          }),
        ),
      ),
    );
  }
}

class PlayColumn extends StatefulWidget {
  const PlayColumn({super.key, required this.session});
  final FISSession session;

  @override
  State<PlayColumn> createState() => _PlayColumnState();
}

class _PlayColumnState extends State<PlayColumn> {
  String tmpSpawn = "";

  void setTmpSpawn(String newSpawn) {
    setState(() {
      tmpSpawn = newSpawn;
    });
  }

  @override
  Widget build(BuildContext context) {
    final disableKeyboard = tmpSpawn.length >= 5;
    return Expanded(
      child: Column(
        children: [
          Spawns(plays: widget.session.plays, tmpSpawn: tmpSpawn),
          Keyboard(
            meaning: widget.session.spawn.meaning,
            disabled: disableKeyboard,
            setTmpSpawn: setTmpSpawn,
            isWon: widget.session.winner != null,
            tmpSpawn: tmpSpawn,
          )
        ],
      ),
    );
  }
}

class Spawns extends StatelessWidget {
  const Spawns({super.key, required this.plays, required this.tmpSpawn});
  final List<List<Plays>> plays;
  final String tmpSpawn;
  @override
  Widget build(BuildContext context) {
    // Current Index rep index of where I can edit now
    final currentIndex = plays.isEmpty ? 0 : plays.length - 1;
    return Column(
      children: List.generate(
        5,
        (yIndex) => Row(
          children: List.generate(
            5,
            (xIndex) {
              return SpawnChar(
                type: (yIndex >= currentIndex
                    ? MatchType.noMatch
                    : plays[yIndex][xIndex].type),
                char: yIndex < currentIndex
                    ? plays[yIndex][xIndex].char
                    : (currentIndex == yIndex
                        ? (xIndex < tmpSpawn.length ? tmpSpawn[xIndex] : "")
                        : ""),
              );
            },
          ).toList(),
        ),
      ).toList(),
    );
  }
}

class SpawnChar extends StatelessWidget {
  const SpawnChar({super.key, required this.type, required this.char});
  final MatchType type;
  final String char;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: 60,
      decoration: BoxDecoration(
        color: type == MatchType.exactMatch
            ? Colors.green.shade400
            : (type == MatchType.noMatch
                ? Colors.transparent
                : Colors.orange.shade400),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade900, width: 2.0),
      ),
      child: Text(
        char,
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}

typedef VoidCallbackWithString = void Function(String);

class Keyboard extends StatelessWidget {
  const Keyboard({
    super.key,
    required this.meaning,
    required this.disabled,
    required this.setTmpSpawn,
    required this.isWon,
    required this.tmpSpawn,
  });
  final String meaning;
  final bool disabled;
  final VoidCallbackWithString setTmpSpawn;
  final bool isWon;
  final String tmpSpawn;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: keys
              .elementAt(0)
              .map((key) => MyKey(
                    text: key,
                    action: () {
                      if (!disabled) {
                        setTmpSpawn(tmpSpawn + key);
                      }
                    },
                  ))
              .toList(),
        ),
        Row(
          children: keys
              .elementAt(1)
              .map((key) => MyKey(
                    text: key,
                    action: () {
                      if (!disabled) {
                        setTmpSpawn(tmpSpawn + key);
                      }
                    },
                  ))
              .toList(),
        ),
        Row(
          children: keys
              .elementAt(2)
              .map((key) => MyKey(
                    text: key,
                    action: () {
                      if (key == "Copy") {
                        if (isWon) {}
                      } else if (key == "Del") {
                        if (tmpSpawn.isNotEmpty) {
                          setTmpSpawn(
                              tmpSpawn.substring(0, tmpSpawn.length - 1));
                        }
                      } else {
                        if (!disabled) {
                          setTmpSpawn(tmpSpawn + key);
                        }
                      }
                    },
                  ))
              .toList(),
        )
      ],
    );
  }
}

class MyKey extends StatelessWidget {
  const MyKey({super.key, required this.text, required this.action});
  final String text;
  final VoidCallback action;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: action,
      child: Container(
        height: 30,
        width: 30,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.grey.shade900, width: 2.0)),
        child: Text(
          text,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

class FISActions extends StatelessWidget {
  FISActions({super.key, required this.fis});
  final FIS fis;
  final server = Server();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: fis.isAuthor
            ? [
                ActionButton(
                  text: 'End Fispawn',
                  action: () => server.changeStatus(fis.id, FISStatus.ended),
                  dialogContent: 'Are you sure you want to nd Fispawn?',
                  dialogActionText: 'End Fispawn',
                  dialogActionSuccessText: 'Fispawn Ended Successfully',
                  dialogActionErrorText: 'Something went wrong',
                ),
                const SizedBox(width: 10),
                MyButton(
                    title: 'Restart Fispawn', function: () {}, isDanger: false),
              ]
            : [
                MyButton(
                    title: 'Leave Fispawn', function: () {}, isDanger: true)
              ],
      ),
    );
  }
}
