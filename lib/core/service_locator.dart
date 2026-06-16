import 'package:dio/dio.dart';

import '../core/api/dio_client.dart';
import '../features/matches/domain/usecases/get_match_detail.dart';
import '../features/matches/domain/usecases/get_matches_by_date.dart';
import '../features/matches/infrastructure/datasources/countries_remote_datasource.dart';
import '../features/matches/infrastructure/datasources/football_remote_datasource.dart';
import '../features/matches/infrastructure/repositories/match_repository_impl.dart';

class ServiceLocator {
  static late final DioClient dioClient;
  static late final FootballRemoteDataSource footballDataSource;
  static late final CountriesRemoteDataSource countriesDataSource;
  static late final MatchRepositoryImpl matchRepository;
  static late final GetMatchesByDate getMatchesByDate;
  static late final GetMatchDetail getMatchDetail;

  static void init() {
    dioClient = DioClient();

    footballDataSource = FootballRemoteDataSource(dioClient);
    countriesDataSource = CountriesRemoteDataSource(Dio());

    matchRepository = MatchRepositoryImpl(
      footballDataSource,
      countriesDataSource,
    );

    getMatchesByDate = GetMatchesByDate(matchRepository);
    getMatchDetail = GetMatchDetail(matchRepository);
  }
}
