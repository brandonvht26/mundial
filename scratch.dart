import 'dart:convert';
import 'package:dio/dio.dart';

void main() async {
  final dio = Dio();
  final res = await dio.get('https://worldcup26.ir/get/games');
  final data = res.data['games'] as List;
  final rounds = data.map((e) => e['group'] ?? e['type']).toSet();
  print(rounds);
}
