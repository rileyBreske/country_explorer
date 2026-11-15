class Country {
  final String code;
  final String name;
  final String emoji;
  final String capital;
  final String continent;
  final String currency;
  final List<String> languages;
  final String phone;

  Country({
    required this.code,
    required this.name,
    required this.emoji,
    required this.capital,
    required this.continent,
    required this.currency,
    required this.languages,
    required this.phone,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    List<String> languages = [];
    if (json['languages'] != null) {
      for (var lang in json['languages']) {
        languages.add(lang['name']);
      }
    }

    return Country(
      code: json['code'] ?? '',
      name: json['name'] ?? 'Unknown',
      emoji: json['emoji'] ?? '',
      capital: json['capital'] ?? 'N/A',
      continent: json['continent']?['name'] ?? 'N/A',
      currency: json['currency'] ?? 'N/A',
      languages: languages,
      phone: json['phone'] ?? 'N/A',
    );
  }

  String get flagUrl => 'https://flagcdn.com/w320/${code.toLowerCase()}.png';
}
