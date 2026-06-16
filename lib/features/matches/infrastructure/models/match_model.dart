import '../../domain/entities/match.dart';
import '../../domain/entities/match_status.dart';
import 'team_model.dart';

class MatchModel {
  final int id;
  final String date;
  final String? stadium;
  final int? stadiumCapacity;
  final String statusShort;
  final TeamModel home;
  final TeamModel away;
  final int? homeGoals;
  final int? awayGoals;
  final String round;
  final List<String> homeScorers;
  final List<String> awayScorers;

  const MatchModel({
    required this.id,
    required this.date,
    this.stadium,
    this.stadiumCapacity,
    required this.statusShort,
    required this.home,
    required this.away,
    this.homeGoals,
    this.awayGoals,
    required this.round,
    this.homeScorers = const [],
    this.awayScorers = const [],
  });

  factory MatchModel.fromJson(Map<String, dynamic> json) {
    String translateTeamName(String name) {
      if (name == 'TBD') return 'Por Definir';
      String translated = name;
      
      // Mapear "Group X winners" a "Ganador Grupo X"
      translated = translated.replaceAllMapped(
        RegExp(r'Group ([A-L]) winners', caseSensitive: false),
        (match) => 'Ganador Grupo ${match.group(1)}',
      );
      
      // Mapear "Group X runners-up" a "Segundo Grupo X"
      translated = translated.replaceAllMapped(
        RegExp(r'Group ([A-L]) runners-up', caseSensitive: false),
        (match) => 'Segundo Grupo ${match.group(1)}',
      );
      
      // Mapear "Group X/Y/Z third place" a "3ro Grupo X/Y/Z"
      translated = translated.replaceAllMapped(
        RegExp(r'Group ([\w/]+) third place', caseSensitive: false),
        (match) => '3ro Grupo ${match.group(1)}',
      );
      
      translated = translated.replaceAll('Winner Match', 'Ganador Partido');
      translated = translated.replaceAll('Loser Match', 'Perdedor Partido');
      translated = translated.replaceAll('Winner', 'Ganador');
      translated = translated.replaceAll('Runner-up', 'Segundo');
      translated = translated.replaceAll('1st', '1ro');
      translated = translated.replaceAll('2nd', '2do');
      translated = translated.replaceAll('3rd', '3ro');
      translated = translated.replaceAll('Group', 'Grupo');
      translated = translated.replaceAll('winners', 'Ganador');
      translated = translated.replaceAll('runners-up', 'Segundo');
      translated = translated.replaceAll('third place', 'Tercer Lugar');
      return translated;
    }

    List<String> parseScorers(dynamic data) {
      if (data == null || data == 'null') return [];
      String s = data.toString();
      s = s.replaceAll(RegExp(r'[{}"\]\[]'), '');
      if (s.isEmpty) return [];
      return s.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
    }

    String translateStadium(String id) {
      switch (id) {
        case '1': return 'Estadio Azteca, CDMX';
        case '2': return 'Estadio Akron, Guadalajara';
        case '3': return 'Estadio BBVA, Monterrey';
        case '4': return 'Estadio AT&T, Dallas';
        case '5': return 'Estadio NRG, Houston';
        case '6': return 'Estadio Arrowhead, Kansas City';
        case '7': return 'Estadio Mercedes-Benz, Atlanta';
        case '8': return 'Estadio Hard Rock, Miami';
        case '9': return 'Estadio Gillette, Boston';
        case '10': return 'Estadio Lincoln Financial, Filadelfia';
        case '11': return 'Estadio MetLife, Nueva York';
        case '12': return 'Estadio BMO, Toronto';
        case '13': return 'Estadio BC Place, Vancouver';
        case '14': return 'Estadio Lumen, Seattle';
        case '15': return "Estadio Levi's, San Francisco";
        case '16': return 'Estadio SoFi, Los Ángeles';
        default: return 'Por Definir';
      }
    }

    int? getStadiumCapacity(String id) {
      switch (id) {
        case '1': return 83000;
        case '2': return 48000;
        case '3': return 53500;
        case '4': return 94000;
        case '5': return 72000;
        case '6': return 73000;
        case '7': return 75000;
        case '8': return 65000;
        case '9': return 65000;
        case '10': return 69000;
        case '11': return 82500;
        case '12': return 45000;
        case '13': return 54000;
        case '14': return 69000;
        case '15': return 71000;
        case '16': return 70000;
        default: return null;
      }
    }

    final int matchId = int.tryParse(json['id'].toString()) ?? 0;
    
    // La API provee "date" como ISO String y "local_date"
    final String dateStr = json['date'] as String? ?? json['local_date'] as String? ?? '';
    
    int? homeGoals = int.tryParse(json['home_score'].toString());
    int? awayGoals = int.tryParse(json['away_score'].toString());
    String statusShort = json['time_elapsed'] as String? ?? 'notstarted';

    return MatchModel(
      id: matchId,
      date: dateStr,
      stadium: translateStadium(json['stadium_id']?.toString() ?? ''),
      stadiumCapacity: getStadiumCapacity(json['stadium_id']?.toString() ?? ''),
      statusShort: statusShort,
      home: TeamModel(id: 0, name: translateTeamName(json['home_team_name_en'] as String? ?? json['home_team_label'] as String? ?? 'TBD')),
      away: TeamModel(id: 0, name: translateTeamName(json['away_team_name_en'] as String? ?? json['away_team_label'] as String? ?? 'TBD')),
      homeGoals: homeGoals,
      awayGoals: awayGoals,
      round: json['group'] as String? ?? json['type'] as String? ?? 'Final Stage',
      homeScorers: parseScorers(json['home_scorers']),
      awayScorers: parseScorers(json['away_scorers']),
    );
  }

  MatchStatus get matchStatus {
    switch (statusShort.toLowerCase()) {
      case 'notstarted':
      case 'ns':
        return MatchStatus.scheduled;
      case 'finished':
      case 'ft':
      case 'aet':
      case 'pen':
        return MatchStatus.finished;
      case 'live':
      case 'ht':
      case '45':
      case 'playing':
        return MatchStatus.live;
      default:
        return MatchStatus.unknown;
    }
  }

  String? get group {
    if (round.length == 1) { // "A", "B", etc
      return 'Grupo $round';
    }
    if (round.toLowerCase().startsWith('group')) {
      return round; 
    }
    return null;
  }

  String get phase {
    if (round.length == 1 || round.toLowerCase().startsWith('group')) {
      return 'Fase de Grupos';
    }
    
    // Traducir fases eliminatorias
    if (round.toLowerCase().contains('round-of-32')) return 'Dieciseisavos de Final';
    if (round.toLowerCase().contains('round-of-16')) return 'Octavos de Final';
    if (round.toLowerCase().contains('quarter-final') || round.toLowerCase().contains('quarterfinal')) return 'Cuartos de Final';
    if (round.toLowerCase().contains('semi-final') || round.toLowerCase().contains('semifinal')) return 'Semifinal';
    if (round.toLowerCase().contains('third-place')) return 'Tercer Lugar';
    if (round.toLowerCase().contains('final')) return 'Final';

    return 'Fase Eliminatoria';
  }

  Match toEntity({
    String? homeFlagUrl,
    String? awayFlagUrl,
    String? homeTranslatedName,
    String? awayTranslatedName,
  }) {
    return Match(
      id: id,
      homeTeam: home.toEntity(
        flagUrl: homeFlagUrl,
        translatedName: homeTranslatedName,
      ),
      awayTeam: away.toEntity(
        flagUrl: awayFlagUrl,
        translatedName: awayTranslatedName,
      ),
      homeScore: homeGoals,
      awayScore: awayGoals,
      status: matchStatus,
      dateTime: _parseDate(date, stadium ?? ''),
      stadium: stadium,
      stadiumCapacity: stadiumCapacity,
      group: group,
      phase: phase,
      homeScorers: homeScorers,
      awayScorers: awayScorers,
    );
  }

  DateTime _parseDate(String dateStr, String stadiumName) {
    int getUtcOffset() {
      if (stadiumName.contains('CDMX') || stadiumName.contains('Guadalajara') || stadiumName.contains('Monterrey')) return 6;
      if (stadiumName.contains('Dallas') || stadiumName.contains('Houston') || stadiumName.contains('Kansas City')) return 5;
      if (stadiumName.contains('Atlanta') || stadiumName.contains('Miami') || stadiumName.contains('Boston') || stadiumName.contains('Filadelfia') || stadiumName.contains('Nueva York') || stadiumName.contains('Toronto')) return 4;
      if (stadiumName.contains('Vancouver') || stadiumName.contains('Seattle') || stadiumName.contains('San Francisco') || stadiumName.contains('Los Ángeles')) return 7;
      return 5; // Por defecto
    }

    try {
      // Intentar parsear formato "06/13/2026 21:00"
      final parts = dateStr.split(' ');
      if (parts.length == 2 && parts[0].contains('/')) {
        final dateParts = parts[0].split('/');
        final timeParts = parts[1].split(':');
        // La API devuelve la hora local del estadio
        final localTime = DateTime.utc(
          int.parse(dateParts[2]),
          int.parse(dateParts[0]),
          int.parse(dateParts[1]),
          int.parse(timeParts[0]),
          int.parse(timeParts[1]),
        );
        return localTime.add(Duration(hours: getUtcOffset()));
      }
      return DateTime.tryParse(dateStr) ?? DateTime.now();
    } catch (e) {
      return DateTime.tryParse(dateStr) ?? DateTime.now();
    }
  }
}
