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
    final fixture = json['fixture'] as Map<String, dynamic>;
    final league = json['league'] as Map<String, dynamic>;
    final teams = json['teams'] as Map<String, dynamic>;
    final goals = json['goals'] as Map<String, dynamic>?;
    final venue = fixture['venue'] as Map<String, dynamic>?;
    final status = fixture['status'] as Map<String, dynamic>;

    return MatchModel(
      id: fixture['id'] as int,
      date: fixture['date'] as String,
      stadium: venue?['name'] as String?,
      statusShort: status['short'] as String,
      home: TeamModel.fromJson(teams['home'] as Map<String, dynamic>),
      away: TeamModel.fromJson(teams['away'] as Map<String, dynamic>),
      homeGoals: goals?['home'] as int?,
      awayGoals: goals?['away'] as int?,
      round: league['round'] as String,
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
    final lower = round.toLowerCase();
    return lower.startsWith('group') ? round : null;
  }

  String get phase {
    final lower = round.toLowerCase();
    return lower.startsWith('group') ? 'Group Stage' : round;
  }

  Match toEntity({
    String? homeFlagUrl,
    String? awayFlagUrl,
    String? homeShortName,
    String? awayShortName,
  }) {
    return Match(
      id: id,
      homeTeam: home.toEntity(flagUrl: homeFlagUrl, shortName: homeShortName),
      awayTeam: away.toEntity(flagUrl: awayFlagUrl, shortName: awayShortName),
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
