import 'package:dio/dio.dart';

import '../../../../../core/api/dio_client.dart';
import '../models/match_model.dart';

class FootballRemoteDataSource {
  final DioClient _dioClient;
  List<MatchModel>? _cachedMatches;
  DateTime? _lastFetchTime;

  FootballRemoteDataSource(this._dioClient);

  Future<List<MatchModel>> _getAllMatches() async {
    if (_cachedMatches != null && _lastFetchTime != null) {
      final diff = DateTime.now().difference(_lastFetchTime!);
      // La caché dura 5 minutos en memoria para balancear rapidez y frescura
      if (diff.inMinutes < 5) {
        return _cachedMatches!;
      }
    }

    final response = await _dioClient.dio.get('/get/games');
    final data = response.data as Map<String, dynamic>;
    final fixtures = data['games'] as List<dynamic>? ?? [];

    _cachedMatches = fixtures
        .map((fixture) => MatchModel.fromJson(fixture as Map<String, dynamic>))
        .toList();
    _lastFetchTime = DateTime.now();

    return _cachedMatches!;
  }

  Future<List<MatchModel>> getFixturesByDate(DateTime date) async {
    try {
      final allMatches = await _getAllMatches();

      return allMatches.where((match) {
        final matchDateUtc = match.toEntity().dateTime;
        // Forzamos a zona horaria de Ecuador (-5) antes de extraer el día/mes/año
        final ecuadorDate = matchDateUtc.subtract(const Duration(hours: 5));
        
        return ecuadorDate.year == date.year &&
            ecuadorDate.month == date.month &&
            ecuadorDate.day == date.day;
      }).toList();
    } on DioException catch (e) {
      final errorMsg = e.message ?? e.error?.toString() ?? 'Error desconocido';
      throw Exception('Error al obtener los partidos: $errorMsg');
    }
  }

  Future<MatchModel> getFixtureById(int id) async {
    try {
      final allMatches = await _getAllMatches();

      return allMatches.firstWhere(
        (match) => match.id.toString() == id.toString(),
        orElse: () => throw Exception('No se encontró el partido con id $id'),
      );
    } on DioException catch (e) {
      final errorMsg = e.message ?? e.error?.toString() ?? 'Error desconocido';
      throw Exception('Error al obtener el detalle del partido: $errorMsg');
    }
  }
}
