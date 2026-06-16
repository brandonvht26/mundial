import 'match_status.dart';
import 'team.dart';

class Match {
  final int id;
  final Team homeTeam;
  final Team awayTeam;
  final int? homeScore;
  final int? awayScore;
  final MatchStatus status;
  final DateTime dateTime;
  final String? stadium;
  final String? group;
  final String phase;

  const Match({
    required this.id,
    required this.homeTeam,
    required this.awayTeam,
    this.homeScore,
    this.awayScore,
    required this.status,
    required this.dateTime,
    this.stadium,
    this.group,
    required this.phase,
  });

  String get scoreDisplay {
    if (status == MatchStatus.scheduled) return 'vs';
    if (homeScore == null || awayScore == null) return 'vs';
    return '$homeScore - $awayScore';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Match && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'Match(id: $id, ${homeTeam.name} vs ${awayTeam.name}, $phase)';
}
