import 'package:dio/dio.dart';

import '../../../../../core/api/dio_client.dart';
import '../models/match_model.dart';

class FootballRemoteDataSource {
  final DioClient _dioClient;

  const FootballRemoteDataSource(this._dioClient);

  Future<List<MatchModel>> getFixturesByDate(DateTime date) async {
    try {
      final response = await _dioClient.dio.get('/world-cup/data/fixtures.json');

      final data = response.data as Map<String, dynamic>;
      final fixtures = data['fixtures'] as List<dynamic>? ?? [];

      return fixtures
          .map((fixture) => MatchModel.fromJson(fixture as Map<String, dynamic>))
          .where((match) {
        final matchDate = DateTime.parse(match.date);
        return matchDate.year == date.year &&
            matchDate.month == date.month &&
            matchDate.day == date.day;
      }).toList();
    } on DioException catch (e) {
      throw Exception('Error al obtener los partidos: ${e.message}');
    }
  }

  Future<MatchModel> getFixtureById(int id) async {
    try {
      final response = await _dioClient.dio.get('/world-cup/data/fixtures.json');

      final data = response.data as Map<String, dynamic>;
      final fixtures = data['fixtures'] as List<dynamic>? ?? [];

      final matchData = fixtures.firstWhere(
        (fixture) => (fixture['matchNumber'] as int) == id,
        orElse: () => throw Exception('No se encontró el partido con id $id'),
      );

      return MatchModel.fromJson(matchData as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception('Error al obtener el detalle del partido: ${e.message}');
    }
  }
}
