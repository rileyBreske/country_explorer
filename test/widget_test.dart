import 'dart:convert';

import 'package:country_explorer/models/country.dart';
import 'package:country_explorer/screens/country_list_screen.dart';
import 'package:country_explorer/services/country_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

final testData = {
  'data': {
    'countries': [
      {
        'code': 'JP',
        'name': 'Japan',
        'emoji': '🇯🇵',
        'capital': 'Tokyo',
        'currency': 'JPY',
        'phone': '81',
        'continent': {'name': 'Asia'},
        'languages': [
          {'name': 'Japanese'},
        ],
      },
    ],
  },
};

CountryService fakeService(int statusCode, Object body) {
  return CountryService(
    client: MockClient((request) async {
      return http.Response(
        jsonEncode(body),
        statusCode,
        headers: {'content-type': 'application/json; charset=utf-8'},
      );
    }),
  );
}

// MyApp needs Firebase now, so the tests build the country list screen directly
Widget testApp(CountryService service) {
  return MaterialApp(
    home: CountryListScreen(service: service, email: 'test@example.com'),
  );
}

void main() {
  test('Country.fromJson handles missing fields', () {
    final country = Country.fromJson({'code': 'AQ', 'name': 'Antarctica'});
    expect(country.capital, 'N/A');
    expect(country.languages, isEmpty);
  });

  testWidgets('shows list and opens detail screen', (tester) async {
    await tester.pumpWidget(testApp(fakeService(200, testData)));
    await tester.pumpAndSettle();

    expect(find.text('Japan'), findsOneWidget);
    expect(find.text('Welcome! test@example.com'), findsOneWidget);

    await tester.tap(find.text('Japan'));
    await tester.pumpAndSettle();

    expect(find.text('Tokyo'), findsOneWidget);
  });

  testWidgets('search filters the list', (tester) async {
    await tester.pumpWidget(testApp(fakeService(200, testData)));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'jap');
    await tester.pump();
    expect(find.text('Japan'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'xyz');
    await tester.pump();
    expect(find.text('No matches.'), findsOneWidget);
  });

  testWidgets('shows error and retry button', (tester) async {
    await tester.pumpWidget(testApp(fakeService(500, {})));
    await tester.pumpAndSettle();

    expect(find.text('Could not load countries.'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
  });
}
