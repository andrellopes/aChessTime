class ChessTimePreset {
  final String id;
  final String nameKey;
  final Duration initialTime;
  final Duration increment;
  final String icon;
  final bool isCustom;
  final String? customName;

  const ChessTimePreset({
    required this.id,
    required this.nameKey,
    required this.initialTime,
    required this.increment,
    required this.icon,
    this.isCustom = false,
    this.customName,
  });

  // Method to create custom preset
  ChessTimePreset.custom({
    required this.id,
    required this.initialTime,
    required this.increment,
    required this.customName,
  }) : nameKey = 'custom',
       icon = 'tune',
       isCustom = true;

  Map<String, dynamic> toJson() => {
    'id': id,
    'nameKey': nameKey,
    'initialTime': initialTime.inMinutes,
    'increment': increment.inSeconds,
    'icon': icon,
    'isCustom': isCustom,
    'customName': customName,
  };

  factory ChessTimePreset.fromJson(Map<String, dynamic> json) => ChessTimePreset(
    id: json['id'],
    nameKey: json['nameKey'],
    initialTime: Duration(minutes: json['initialTime']),
    increment: Duration(seconds: json['increment']),
    icon: json['icon'],
    isCustom: json['isCustom'] ?? false,
    customName: json['customName'],
  );

  @override
  bool operator ==(Object other) =>
    identical(this, other) ||
    other is ChessTimePreset &&
    runtimeType == other.runtimeType &&
    id == other.id;

  @override
  int get hashCode => id.hashCode;
}

// Default presets
const List<ChessTimePreset> defaultChessPresets = [
  // Torneio
  ChessTimePreset(
    id: 'tournament',
    nameKey: 'presetTournament',
    initialTime: Duration(minutes: 15),
    increment: Duration(seconds: 10),
    icon: 'emoji_events',
  ),
  
  // Blitz
  ChessTimePreset(
    id: 'blitz',
    nameKey: 'presetBlitz',
    initialTime: Duration(minutes: 5),
    increment: Duration(seconds: 3),
    icon: 'flash_on',
  ),
  
  // Bullet
  ChessTimePreset(
    id: 'bullet',
    nameKey: 'presetBullet',
    initialTime: Duration(minutes: 1),
    increment: Duration(seconds: 1),
    icon: 'speed',
  ),
  
  // Rapid
  ChessTimePreset(
    id: 'rapid',
    nameKey: 'presetRapid',
    initialTime: Duration(minutes: 10),
    increment: Duration(seconds: 5),
    icon: 'timer',
  ),
  
  // Classical
  ChessTimePreset(
    id: 'classical',
    nameKey: 'presetClassical',
    initialTime: Duration(minutes: 30),
    increment: Duration(seconds: 30),
    icon: 'account_balance',
  ),
  
  // Long - 90 minutes for extended games
  ChessTimePreset(
    id: 'long',
    nameKey: 'presetLong',
    initialTime: Duration(minutes: 90),
    increment: Duration(seconds: 30),
    icon: 'schedule',
  ),
  
  // No increment - Basic
  ChessTimePreset(
    id: 'basic',
    nameKey: 'presetBasic',
    initialTime: Duration(minutes: 10),
    increment: Duration.zero,
    icon: 'play_circle',
  ),
];
