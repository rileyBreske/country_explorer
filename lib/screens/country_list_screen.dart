import 'package:flutter/material.dart';

import '../models/country.dart';
import '../services/country_service.dart';
import '../widgets/country_card.dart';
import 'country_detail_screen.dart';

class CountryListScreen extends StatefulWidget {
  final CountryService service;

  const CountryListScreen({super.key, required this.service});

  @override
  State<CountryListScreen> createState() => _CountryListScreenState();
}

class _CountryListScreenState extends State<CountryListScreen> {
  late Future<List<Country>> futureCountries;

  @override
  void initState() {
    super.initState();
    futureCountries = widget.service.fetchCountries();
  }

  void loadCountries() {
    setState(() {
      futureCountries = widget.service.fetchCountries();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Country Explorer')),
      body: FutureBuilder<List<Country>>(
        future: futureCountries,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, size: 50, color: Colors.red),
                  const SizedBox(height: 10),
                  const Text('Could not load countries.'),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: loadCountries,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final countries = snapshot.data ?? [];

          if (countries.isEmpty) {
            return const Center(child: Text('No countries found.'));
          }

          return ListView.builder(
            itemCount: countries.length,
            itemBuilder: (context, index) {
              final country = countries[index];
              return CountryCard(
                country: country,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CountryDetailScreen(country: country),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
