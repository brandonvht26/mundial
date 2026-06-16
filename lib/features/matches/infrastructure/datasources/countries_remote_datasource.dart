import 'package:dio/dio.dart';

import '../models/country_model.dart';

class CountriesRemoteDataSource {
  final Dio _dio;

  const CountriesRemoteDataSource(this._dio);

  Future<CountryModel?> getCountryByName(String name) async {
    try {
      final response = await _dio.get(
        'https://restcountries.com/v3.1/name/$name',
        queryParameters: {'fields': 'flags,name,fifa'},
      );

      final data = response.data as List<dynamic>;
      if (data.isEmpty) return null;

      return CountryModel.fromJson(data.first as Map<String, dynamic>);
    } on DioException {
      return null;
    }
  }

  Future<String?> getFlagSvgByCountryName(
    String name, {
    String? fallbackName,
  }) async {
    final country = await getCountryByName(name);
    if (country != null && country.flagSvg != null) {
      return country.flagSvg;
    }

    if (fallbackName != null && fallbackName != name) {
      final fallback = await getCountryByName(fallbackName);
      return fallback?.flagSvg;
    }

    return null;
  }
}
