import '../entities/match.dart';

abstract class MatchRepository {
  Stream<List<Match>> getMatchesByDate(DateTime date, {bool forceRefresh = false});
  Future<Match> getMatchDetail(int matchId);
}
