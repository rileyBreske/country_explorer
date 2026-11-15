import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/country.dart';

class CountryService {
  final http.Client client;

  CountryService({http.Client? client}) : client = client ?? http.Client();

  final String url = 'https://countries.trevorblades.com/';

  final String query = '''
    {
      countries {
        code
        name
        emoji
        capital
        currency
        phone
        continent { name }
        languages { name }
      }
    }
  ''';

  Future<List<Country>> fetchCountries() async {
    final response = await client.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'query': query}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load countries');
    }

    final data = jsonDecode(utf8.decode(response.bodyBytes));
    final List list = data['data']?['countries'] ?? [];

    List<Country> countries = list.map((c) => Country.fromJson(c)).toList();
    countries.sort((a, b) => a.name.compareTo(b.name));
    return countries;
  }
}
