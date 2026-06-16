import '../../domain/entities/team.dart';

class TeamModel {
  final int id;
  final String name;
  final String? logo;

  const TeamModel({
    required this.id,
    required this.name,
    this.logo,
  });

  factory TeamModel.fromJson(Map<String, dynamic> json) {
    return TeamModel(
      id: json['id'] as int,
      name: json['name'] as String,
      logo: json['logo'] as String?,
    );
  }

  Team toEntity({String? flagUrl, String? shortName}) {
    return Team(
      id: id,
      name: name,
      shortName: shortName,
      logoUrl: flagUrl ?? logo,
    );
  }
}
