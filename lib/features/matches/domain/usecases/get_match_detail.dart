import '../entities/match.dart';
import '../repositories/match_repository.dart';

class GetMatchDetail {
  final MatchRepository _repository;

  const GetMatchDetail(this._repository);

  Future<Match> call(int matchId) => _repository.getMatchDetail(matchId);
}
