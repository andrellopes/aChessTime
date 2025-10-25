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
  final Duration increment;

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
    required this.increment,
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
      'increment': increment.inMilliseconds,
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
      increment: Duration(milliseconds: json['increment']),
    );
  }

  bool get isTimeoutResult => resultType.startsWith('timeout_');
  bool get isManualResult => resultType.startsWith('manual_');
  bool get isDraw => resultType == 'draw';
  bool get whiteWon => winner == 'white';
  bool get blackWon => winner == 'black';
}