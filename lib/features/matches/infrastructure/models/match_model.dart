import '../../domain/entities/match.dart';
import '../../domain/entities/match_status.dart';
import 'team_model.dart';

class MatchModel {
  final int id;
  final String date;
  final String? stadium;
  final String statusShort;
  final TeamModel home;
  final TeamModel away;
  final int? homeGoals;
  final int? awayGoals;
  final String round;

  const MatchModel({
    required this.id,
    required this.date,
    this.stadium,
    required this.statusShort,
    required this.home,
    required this.away,
    this.homeGoals,
    this.awayGoals,
    required this.round,
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
      translated = translated.replaceAll('Group', 'Grupo');
      translated = translated.replaceAll('winners', 'Ganador');
      translated = translated.replaceAll('runners-up', 'Segundo');
      translated = translated.replaceAll('third place', 'Tercer Lugar');
      return translated;
    }

    final int matchId = json['matchNumber'] as int;
    final String dateStr = (json['kickoffUtc'] as String).replaceAll(' ', 'T');
    
    int? homeGoals = json['homeTeamScore'] as int?;
    int? awayGoals = json['awayTeamScore'] as int?;
    String statusShort = json['statusShort'] as String? ?? 'NS';

    return MatchModel(
      id: matchId,
      date: dateStr,
      stadium: json['stadium'] as String?,
      statusShort: statusShort,
      home: TeamModel(id: 0, name: translateTeamName(json['homeTeam'] as String)),
      away: TeamModel(id: 0, name: translateTeamName(json['awayTeam'] as String)),
      homeGoals: homeGoals,
      awayGoals: awayGoals,
      round: json['group'] as String? ?? json['stage'] as String? ?? 'Final Stage',
    );
  }

  MatchStatus get matchStatus {
    switch (statusShort.toUpperCase()) {
      case 'NS':
        return MatchStatus.scheduled;
      case 'FT':
      case 'AET':
      case 'PEN':
      case 'AWD':
      case 'WO':
        return MatchStatus.finished;
      case '1H':
      case 'HT':
      case '2H':
      case 'ET':
      case 'P':
      case 'BT':
      case 'INT':
      case 'SUSP':
      case 'LIVE':
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
      dateTime: DateTime.parse(date),
      stadium: stadium,
      group: group,
      phase: phase,
    );
  }
}
