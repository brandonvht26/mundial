import 'package:dio/dio.dart';

void main() async {
  print('Fetching fixtures...');
  final dio = Dio();
  final response = await dio.get('https://www.thestatsapi.com/world-cup/data/fixtures.json');
  final data = response.data as Map<String, dynamic>;
  final fixtures = data['fixtures'] as List<dynamic>? ?? [];
  final matches = fixtures.where((f) => f['homeTeam'] == 'Ecuador' || f['awayTeam'] == 'Ecuador').toList();
  print('Ecuador Matches: ${matches.length}');
  for (var f in matches) {
    print('${f['date']} - ${f['kickoffUtc']} : ${f['homeTeam']} vs ${f['awayTeam']}');
  }
}
