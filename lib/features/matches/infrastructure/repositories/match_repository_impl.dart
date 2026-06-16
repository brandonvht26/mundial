import '../../domain/entities/match.dart';
import '../../domain/repositories/match_repository.dart';
import '../datasources/countries_remote_datasource.dart';
import '../datasources/country_codes.dart';
import '../datasources/football_local_datasource.dart';
import '../datasources/football_remote_datasource.dart';
import '../models/match_model.dart';

class MatchRepositoryImpl implements MatchRepository {
  final FootballRemoteDataSource _remoteDataSource;
  final FootballLocalDataSource _localDataSource;
  final LocalCountriesDataSource _countriesDataSource;

  const MatchRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
    this._countriesDataSource,
  );

  List<MatchModel> _filterModelsByDate(List<MatchModel> allMatches, DateTime date) {
    return allMatches.where((match) {
      final matchDateUtc = match.toEntity().dateTime;
      final ecuadorDate = matchDateUtc.subtract(const Duration(hours: 5));
      return ecuadorDate.year == date.year &&
             ecuadorDate.month == date.month &&
             ecuadorDate.day == date.day;
    }).toList();
  }

  @override
  Stream<List<Match>> getMatchesByDate(DateTime date, {bool forceRefresh = false}) async* {
    bool hasYieldedLocal = false;

    // 1. Emitir datos cacheados primero (Stale)
    if (!forceRefresh) {
      final localModels = await _localDataSource.getCachedGames();
      if (localModels != null && localModels.isNotEmpty) {
        final localFiltered = _filterModelsByDate(localModels, date);
        final matches = <Match>[];
        for (final model in localFiltered) {
          matches.add(await _enrichAndMap(model));
        }
        yield matches;
        hasYieldedLocal = true;
      }
    }

    // 2. Traer datos frescos (Revalidate)
    try {
      final rawGames = await _remoteDataSource.fetchRawGames();
      await _localDataSource.cacheGames(rawGames);
      
      final remoteModels = rawGames
          .map((fixture) => MatchModel.fromJson(fixture as Map<String, dynamic>))
          .toList();
      
      final remoteFiltered = _filterModelsByDate(remoteModels, date);
      final freshMatches = <Match>[];
      for (final model in remoteFiltered) {
        freshMatches.add(await _enrichAndMap(model));
      }
      yield freshMatches;
    } catch (e) {
      // Si forzamos actualización o no hay nada local para mostrar, mostrar error
      if (forceRefresh || !hasYieldedLocal) {
        rethrow;
      }
    }
  }

  @override
  Future<Match> getMatchDetail(int matchId) async {
    final localModels = await _localDataSource.getCachedGames();
    if (localModels != null) {
      try {
        final model = localModels.firstWhere((m) => m.id.toString() == matchId.toString());
        return await _enrichAndMap(model);
      } catch (_) {}
    }

    final rawGames = await _remoteDataSource.fetchRawGames();
    final remoteModels = rawGames
          .map((fixture) => MatchModel.fromJson(fixture as Map<String, dynamic>))
          .toList();
    final model = remoteModels.firstWhere(
      (m) => m.id.toString() == matchId.toString(),
      orElse: () => throw Exception('No se encontró el partido con id $matchId'),
    );
    return await _enrichAndMap(model);
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
