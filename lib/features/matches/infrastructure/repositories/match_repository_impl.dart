import '../../domain/entities/match.dart';
import '../../domain/repositories/match_repository.dart';
import '../datasources/countries_remote_datasource.dart';
import '../datasources/football_remote_datasource.dart';
import '../models/country_model.dart';
import '../models/match_model.dart';

class MatchRepositoryImpl implements MatchRepository {
  final FootballRemoteDataSource _footballDataSource;
  final CountriesRemoteDataSource _countriesDataSource;

  const MatchRepositoryImpl(
    this._footballDataSource,
    this._countriesDataSource,
  );

  @override
  Future<List<Match>> getMatchesByDate(DateTime date) async {
    final models = await _footballDataSource.getFixturesByDate(date);
    final matches = <Match>[];

    for (final model in models) {
      final match = await _enrichAndMap(model);
      matches.add(match);
    }

    return matches;
  }

  @override
  Future<Match> getMatchDetail(int matchId) async {
    final model = await _footballDataSource.getFixtureById(matchId);
    return _enrichAndMap(model);
  }

  Future<Match> _enrichAndMap(MatchModel model) async {
    final countries = await Future.wait<CountryModel?>([
      _countriesDataSource.getCountryByName(model.home.name),
      _countriesDataSource.getCountryByName(model.away.name),
    ]);

    final homeCountry = countries[0];
    final awayCountry = countries[1];

    return model.toEntity(
      homeFlagUrl: homeCountry?.flagSvg,
      awayFlagUrl: awayCountry?.flagSvg,
      homeShortName: homeCountry?.fifaCode,
      awayShortName: awayCountry?.fifaCode,
    );
  }
}
