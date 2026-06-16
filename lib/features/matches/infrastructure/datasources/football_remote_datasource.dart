import 'package:dio/dio.dart';

import '../../../../../core/api/dio_client.dart';

class FootballRemoteDataSource {
  final DioClient _dioClient;

  FootballRemoteDataSource(this._dioClient);

  Future<List<dynamic>> fetchRawGames() async {
    try {
      final response = await _dioClient.dio.get('/get/games');
      final data = response.data as Map<String, dynamic>;
      return data['games'] as List<dynamic>? ?? [];
    } on DioException catch (e) {
      final errorMsg = e.message ?? e.error?.toString() ?? 'Error desconocido';
      throw Exception('Error al obtener los partidos de la API: $errorMsg');
    }
  }
}
