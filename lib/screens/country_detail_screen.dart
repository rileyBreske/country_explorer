import 'package:flutter/material.dart';

import '../models/country.dart';

class CountryDetailScreen extends StatelessWidget {
  final Country country;

  const CountryDetailScreen({super.key, required this.country});

  @override
  Widget build(BuildContext context) {
    String languages = country.languages.isEmpty
        ? 'N/A'
        : country.languages.join(', ');

    return Scaffold(
      appBar: AppBar(title: Text(country.name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: Image.network(
              country.flagUrl,
              height: 150,
              errorBuilder: (context, error, stackTrace) =>
                  Text(country.emoji, style: const TextStyle(fontSize: 80)),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            country.name,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.location_city),
                  title: const Text('Capital'),
                  subtitle: Text(country.capital),
                ),
                ListTile(
                  leading: const Icon(Icons.public),
                  title: const Text('Continent'),
                  subtitle: Text(country.continent),
                ),
                ListTile(
                  leading: const Icon(Icons.language),
                  title: const Text('Languages'),
                  subtitle: Text(languages),
                ),
                ListTile(
                  leading: const Icon(Icons.attach_money),
                  title: const Text('Currency'),
                  subtitle: Text(country.currency),
                ),
                ListTile(
                  leading: const Icon(Icons.phone),
                  title: const Text('Phone Code'),
                  subtitle: Text('+${country.phone}'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
