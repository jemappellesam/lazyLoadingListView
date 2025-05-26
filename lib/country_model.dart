class Country {
  final String name;
  final String flag;
  final String capital;
  final int population;
  final String region;
  final String subregion;

  Country({
    required this.name,
    required this.flag,
    required this.capital,
    required this.population,
    required this.region,
    required this.subregion,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      name: json['name']['common'] ?? 'Sem nome',
      flag: json['flags']['png'] ?? '',
      capital: json['capital']?.isNotEmpty == true ? json['capital'][0] : 'N/A',
      population: json['population'] ?? 0,
      region: json['region'] ?? 'N/A',
      subregion: json['subregion'] ?? 'N/A',
    );
  }
}