import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/match_model.dart';

class FootballLocalDataSource {
  final SharedPreferences _prefs;
  static const _cacheKey = 'CACHED_MATCHES_JSON';

  FootballLocalDataSource(this._prefs);

  Future<void> cacheGames(List<dynamic> jsonList) async {
    final jsonString = jsonEncode(jsonList);
    await _prefs.setString(_cacheKey, jsonString);
  }

  Future<List<MatchModel>?> getCachedGames() async {
    final jsonString = _prefs.getString(_cacheKey);
    if (jsonString != null) {
      try {
        final List<dynamic> fixtures = jsonDecode(jsonString);
        return fixtures
            .map((fixture) => MatchModel.fromJson(fixture as Map<String, dynamic>))
            .toList();
      } catch (e) {
        return null;
      }
    }
    return null;
  }
}
