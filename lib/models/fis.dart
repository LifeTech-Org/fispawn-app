enum FISStatus { waiting, ended, live, cancelled }

FISStatus getFISStatusFromString(String status) {
  FISStatus result = FISStatus.waiting;
  switch (status) {
    case 'ended':
      result = FISStatus.ended;
      break;

    case 'live':
      result = FISStatus.live;
      break;

    case 'cancelled':
      result = FISStatus.cancelled;
      break;
  }
  return result;
}

class FIS {
  FIS({
    required this.id,
    required this.category,
    required this.status,
    required this.isMember,
    required this.isAuthor,
    required this.activeSessionId,
    required this.author,
    required this.players,
  });
  String id;
  String category;
  FISStatus status;
  bool isMember;
  bool isAuthor;
  String activeSessionId;
  Player author;
  List<Player> players;

  factory FIS.fromJSON(Map<String, dynamic> data) {
    return FIS(
      id: data['id']!,
      category: data['category'],
      status: getFISStatusFromString(data['status']!),
      isMember: data['isMember'],
      isAuthor: data['isAuthor'],
      activeSessionId: data['activeSessionId'],
      author: Player.fromJSON(data['author']),
      players: List.from(data['players']!)
          .map((player) => Player.fromJSON(player))
          .toList(),
    );
  }
}

class Player {
  Player(
      {required this.uid,
      required this.displayName,
      this.photoURL,
      required this.isAuthor,
      required this.isMe,
      this.ready = false});
  String uid;
  String displayName;
  String? photoURL;
  bool? isAuthor;
  bool? isMe;
  bool? ready;

  factory Player.fromJSON(Map<String, dynamic> data) {
    print(data);
    return Player(
      uid: data['uid'],
      displayName: data['displayName'],
      photoURL: data['photoURL'],
      isAuthor: data['isAuthor'],
      isMe: data['isMe'],
      ready: data['ready'] ?? false,
    );
  }
}

class FISSession {
  List<Player> players;
  String? winner;

  List<List<Plays>> plays;
  bool start;
  List<Stat> stats;
  Spawn spawn;
  FISSession({
    required this.players,
    required this.winner,
    required this.plays,
    required this.start,
    required this.stats,
    required this.spawn,
  });
  factory FISSession.fromJSON(Map<String, dynamic> data) {
    return FISSession(
      players: List.from(data['players'])
          .map((player) => Player.fromJSON(player))
          .toList(),
      winner: data['winner'],
      plays: List.from(data['plays'])
          .map((player) => List.from(player)
              .map((play) => Plays.fromString(play['char'], play['type']))
              .toList())
          .toList(),
      start: data['start'],
      stats: List.from(data['stats'])
          .map((player) => Stat(
              uid: player['uid'],
              counts: player['counts'],
              wins: player['wins']))
          .toList(),
      spawn:
          Spawn(meaning: data['spawn']['meaning'], word: data['spawn']['word']),
    );
  }
}

enum MatchType {
  exactMatch,
  noMatch,
  partialMatch,
}

MatchType getMatchTypeFromString(String matchType) {
  return matchType == "exactMatch"
      ? MatchType.exactMatch
      : (matchType == "partialMatch"
          ? MatchType.partialMatch
          : MatchType.noMatch);
}

class Plays {
  final String char;
  final MatchType type;
  Plays({required this.char, required this.type});

  factory Plays.fromString(String char, String type) {
    return Plays(char: char, type: getMatchTypeFromString(type));
  }
}

class Stat {
  final String uid;
  final int counts;
  final int wins;
  const Stat({required this.uid, required this.counts, required this.wins});
}

class Spawn {
  final String? word;
  final String meaning;
  const Spawn({this.word, required this.meaning});
}
