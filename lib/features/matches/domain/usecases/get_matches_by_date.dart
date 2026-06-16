import '../entities/match.dart';
import '../repositories/match_repository.dart';

class GetMatchesByDate {
  final MatchRepository _repository;

  const GetMatchesByDate(this._repository);

  Future<List<Match>> call(DateTime date) => _repository.getMatchesByDate(date);
}
