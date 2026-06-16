import '../../domain/entities/match.dart';
import '../../domain/repositories/match_repository.dart';
import '../datasources/countries_remote_datasource.dart';
import '../datasources/country_codes.dart';
import '../datasources/football_remote_datasource.dart';
import '../models/match_model.dart';

class MatchRepositoryImpl implements MatchRepository {
  final FootballRemoteDataSource _footballDataSource;
  final LocalCountriesDataSource _countriesDataSource;

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
    final homeFlag = await _countriesDataSource.getFlagSvgByCountryName(model.home.name);
    final awayFlag = await _countriesDataSource.getFlagSvgByCountryName(model.away.name);

    return model.toEntity(
      homeFlagUrl: homeFlag,
      awayFlagUrl: awayFlag,
      homeTranslatedName: CountryCodes.getSpanishName(model.home.name),
      awayTranslatedName: CountryCodes.getSpanishName(model.away.name),
    );
  }
}
