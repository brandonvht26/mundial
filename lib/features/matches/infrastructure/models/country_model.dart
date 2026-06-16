import '../../domain/entities/country.dart';

class CountryModel {
  final String name;
  final String? flagSvg;
  final String? fifaCode;

  const CountryModel({
    required this.name,
    this.flagSvg,
    this.fifaCode,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    final nameMap = json['name'] as Map<String, dynamic>?;
    final flags = json['flags'] as Map<String, dynamic>?;

    return CountryModel(
      name: nameMap?['common'] as String? ?? '',
      flagSvg: flags?['svg'] as String?,
      fifaCode: json['fifa'] as String?,
    );
  }

  Country toEntity() {
    return Country(
      name: name,
      flagUrl: flagSvg,
      fifaCode: fifaCode,
    );
  }
}
