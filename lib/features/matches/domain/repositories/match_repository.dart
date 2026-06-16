import '../entities/match.dart';

abstract class MatchRepository {
  Future<List<Match>> getMatchesByDate(DateTime date);
  Future<Match> getMatchDetail(int matchId);
}
