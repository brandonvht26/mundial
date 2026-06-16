import '../entities/match.dart';
import '../repositories/match_repository.dart';

class GetAllMatches {
  final MatchRepository repository;

  GetAllMatches(this.repository);

  Stream<List<Match>> call({bool forceRefresh = false}) {
    return repository.getAllMatches(forceRefresh: forceRefresh);
  }
}
