import 'package:dio/dio.dart';

import '../../../../../core/api/dio_client.dart';
import '../models/match_model.dart';

class FootballRemoteDataSource {
  final DioClient _dioClient;

  const FootballRemoteDataSource(this._dioClient);

  Future<List<MatchModel>> getFixturesByDate(DateTime date) async {
    try {
      final formattedDate =
          '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

      final response = await _dioClient.dio.get(
        '/fixtures',
        queryParameters: {
          'date': formattedDate,
          'league': 1,
          'season': 2026,
        },
      );

      final data = response.data as Map<String, dynamic>;
      final fixtures = data['response'] as List<dynamic>? ?? [];

      return fixtures
          .map((fixture) => MatchModel.fromJson(fixture as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw Exception('Error al obtener los partidos: ${e.message}');
    }
  }

  Future<MatchModel> getFixtureById(int id) async {
    try {
      final response = await _dioClient.dio.get(
        '/fixtures',
        queryParameters: {'id': id},
      );

      final data = response.data as Map<String, dynamic>;
      final fixtures = data['response'] as List<dynamic>? ?? [];

      if (fixtures.isEmpty) {
        throw Exception('No se encontró el partido con id $id');
      }

      return MatchModel.fromJson(fixtures.first as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception('Error al obtener el detalle del partido: ${e.message}');
    }
  }
}
