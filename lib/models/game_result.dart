class GameResult {
  final String id;
  final DateTime dateTime;
  final String resultType;
  final String? winner;
  final Duration gameDuration;
  final Duration whiteTimeRemaining;
  final Duration blackTimeRemaining;
  final int whiteMoves;
  final int blackMoves;
  final Duration initialTime;
  final Duration? player2InitialTime;
  final Duration increment;
  final String timeMode;

  GameResult({
    required this.id,
    required this.dateTime,
    required this.resultType,
    this.winner,
    required this.gameDuration,
    required this.whiteTimeRemaining,
    required this.blackTimeRemaining,
    required this.whiteMoves,
    required this.blackMoves,
    required this.initialTime,
    this.player2InitialTime,
    required this.increment,
    required this.timeMode,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dateTime': dateTime.toIso8601String(),
      'resultType': resultType,
      'winner': winner,
      'gameDuration': gameDuration.inMilliseconds,
      'whiteTimeRemaining': whiteTimeRemaining.inMilliseconds,
      'blackTimeRemaining': blackTimeRemaining.inMilliseconds,
      'whiteMoves': whiteMoves,
      'blackMoves': blackMoves,
      'initialTime': initialTime.inMilliseconds,
      'player2InitialTime': player2InitialTime?.inMilliseconds,
      'increment': increment.inMilliseconds,
      'timeMode': timeMode,
    };
  }

  factory GameResult.fromJson(Map<String, dynamic> json) {
    return GameResult(
      id: json['id'],
      dateTime: DateTime.parse(json['dateTime']),
      resultType: json['resultType'],
      winner: json['winner'],
      gameDuration: Duration(milliseconds: json['gameDuration']),
      whiteTimeRemaining: Duration(milliseconds: json['whiteTimeRemaining']),
      blackTimeRemaining: Duration(milliseconds: json['blackTimeRemaining']),
      whiteMoves: json['whiteMoves'],
      blackMoves: json['blackMoves'],
      initialTime: Duration(milliseconds: json['initialTime']),
      player2InitialTime: json['player2InitialTime'] != null 
          ? Duration(milliseconds: json['player2InitialTime']) 
          : null,
      increment: Duration(milliseconds: json['increment']),
      timeMode: json['timeMode'] ?? 'TimeMode.fischer',
    );
  }

  bool get isTimeoutResult => resultType.startsWith('timeout_');
  bool get isManualResult => resultType.startsWith('manual_');
  bool get isDraw => resultType == 'draw';
  bool get whiteWon => winner == 'white';
  bool get blackWon => winner == 'black';
}