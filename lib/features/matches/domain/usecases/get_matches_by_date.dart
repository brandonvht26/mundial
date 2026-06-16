import '../entities/match.dart';
import '../repositories/match_repository.dart';

class GetMatchesByDate {
  final MatchRepository _repository;

  const GetMatchesByDate(this._repository);

  Stream<List<Match>> call(DateTime date, {bool forceRefresh = false}) => 
      _repository.getMatchesByDate(date, forceRefresh: forceRefresh);
}
