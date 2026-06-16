import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DioClient {
  late final Dio dio;

  DioClient() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://v3.football.api-sports.io/',
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'x-rapidapi-host': 'v3.football.api-sports.io',
          // Asegúrate de que API_FOOTBALL_KEY coincida con tu .env
          'x-rapidapi-key': dotenv.env['API_FOOTBALL_KEY'] ?? '',
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Lógica previa a la petición (logs, etc)
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          // Manejo centralizado de errores
          return handler.next(e);
        },
      ),
    );
  }
}
