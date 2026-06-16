import 'package:shared_preferences/shared_preferences.dart';
import '../core/api/dio_client.dart';
import '../features/matches/domain/usecases/get_match_detail.dart';
import '../features/matches/domain/usecases/get_matches_by_date.dart';
import '../features/matches/domain/usecases/get_all_matches.dart';
import '../features/matches/infrastructure/datasources/countries_remote_datasource.dart';
import '../features/matches/infrastructure/datasources/football_remote_datasource.dart';
import '../features/matches/infrastructure/datasources/football_local_datasource.dart';
import '../features/matches/infrastructure/repositories/match_repository_impl.dart';

class ServiceLocator {
  static late final SharedPreferences sharedPreferences;
  static late final DioClient dioClient;
  static late final FootballRemoteDataSource footballDataSource;
  static late final FootballLocalDataSource localDataSource;
  static late final LocalCountriesDataSource countriesDataSource;
  static late final MatchRepositoryImpl matchRepository;
  static late final GetMatchesByDate getMatchesByDate;
  static late final GetAllMatches getAllMatches;
  static late final GetMatchDetail getMatchDetail;

  static Future<void> init() async {
    sharedPreferences = await SharedPreferences.getInstance();
    dioClient = DioClient();

    footballDataSource = FootballRemoteDataSource(dioClient);
    localDataSource = FootballLocalDataSource(sharedPreferences);
    countriesDataSource = const LocalCountriesDataSource();

    matchRepository = MatchRepositoryImpl(
      footballDataSource,
      localDataSource,
      countriesDataSource,
    );

    getMatchesByDate = GetMatchesByDate(matchRepository);
    getAllMatches = GetAllMatches(matchRepository);
    getMatchDetail = GetMatchDetail(matchRepository);
  }
}
