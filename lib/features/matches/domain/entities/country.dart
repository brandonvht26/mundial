class Country {
  final String name;
  final String? flagUrl;
  final String? fifaCode;

  const Country({
    required this.name,
    this.flagUrl,
    this.fifaCode,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Country &&
          runtimeType == other.runtimeType &&
          name == other.name;

  @override
  int get hashCode => name.hashCode;

  @override
  String toString() => 'Country(name: $name, fifaCode: $fifaCode)';
}
