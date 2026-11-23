import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/country.dart';
import '../services/country_service.dart';
import '../widgets/country_card.dart';
import 'country_detail_screen.dart';

class CountryListScreen extends StatefulWidget {
  final CountryService service;
  final String email;

  const CountryListScreen({
    super.key,
    required this.service,
    required this.email,
  });

  @override
  State<CountryListScreen> createState() => _CountryListScreenState();
}

class _CountryListScreenState extends State<CountryListScreen> {
  late Future<List<Country>> futureCountries;
  String searchText = '';

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
      appBar: AppBar(
        title: const Text('Country Explorer'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () {
              // main.dart notices the user is gone and shows the login screen
              FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Text(
              'Welcome! ${widget.email}',
              style: const TextStyle(fontSize: 16),
            ),
          ),
          Expanded(child: buildCountryList()),
        ],
      ),
    );
  }

  Widget buildCountryList() {
    return FutureBuilder<List<Country>>(
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

        final filtered = countries
            .where(
              (c) => c.name.toLowerCase().contains(searchText.toLowerCase()),
            )
            .toList();

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Search countries',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    searchText = value;
                  });
                },
              ),
            ),
            Expanded(
              child: filtered.isEmpty
                  ? const Center(child: Text('No matches.'))
                  : ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final country = filtered[index];
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
                    ),
            ),
          ],
        );
      },
    );
  }
}
