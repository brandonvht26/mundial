class Team {
  final int id;
  final String name;
  final String? shortName;
  final String? logoUrl;

  const Team({
    required this.id,
    required this.name,
    this.shortName,
    this.logoUrl,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Team && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Team(id: $id, name: $name)';
}
