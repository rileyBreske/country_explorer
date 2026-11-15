import 'package:flutter/material.dart';

import 'screens/country_list_screen.dart';
import 'services/country_service.dart';

void main() {
  runApp(MyApp(service: CountryService()));
}

class MyApp extends StatelessWidget {
  final CountryService service;

  const MyApp({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Country Explorer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: CountryListScreen(service: service),
    );
  }
}
