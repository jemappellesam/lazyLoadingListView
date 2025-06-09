import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:paises/country_model.dart';
import 'package:paises/country_list_screen.dart';
import 'package:paises/pais_service.dart';

import 'country_list_screen_test.mocks.dart';

@GenerateMocks([PaisService])
void main() {
  late MockPaisService mockPaisService;
  late List<Country> fakeCountries;

  setUp(() {
    mockPaisService = MockPaisService();
    fakeCountries = [
      Country(
        name: 'Brasil',
        capital: 'Brasília',
        region: 'Américas',
        population: 211000000,
        flag: 'https://flagcdn.com/w320/br.png',
        subregion: "america latina"
      ),
      Country(
        name: 'França',
        capital: 'Paris',
        region: 'Europa',
        population: 67000000,
        flag: 'https://flagcdn.com/w320/fr.png',
        subregion: "europa"
      ),
    ];
  });

  testWidgets('01 - Listagem com sucesso', (WidgetTester tester) async {
    when(mockPaisService.listarPaises())
        .thenAnswer((_) async => fakeCountries);

    await tester.pumpWidget(MaterialApp(
      home: CountryListScreen(paisService: mockPaisService),
    ));

    await tester.pumpAndSettle();

    expect(find.text('Brasil'), findsOneWidget);
    expect(find.text('França'), findsOneWidget);
  });

  testWidgets('02 - Falha na listagem', (WidgetTester tester) async {
    when(mockPaisService.listarPaises())
        .thenThrow(Exception('Erro na API'));

    await tester.pumpWidget(MaterialApp(
      home: CountryListScreen(paisService: mockPaisService),
    ));

    await tester.pumpAndSettle();

    expect(find.textContaining('Erro'), findsOneWidget);
  });

  testWidgets('03 - Buscar país específico com sucesso', (WidgetTester tester) async {
    when(mockPaisService.listarPaises())
        .thenAnswer((_) async => fakeCountries);

    when(mockPaisService.buscarPaisPorNome('Brasil'))
        .thenAnswer((_) async => fakeCountries[0]);

    await tester.pumpWidget(MaterialApp(
      home: CountryListScreen(paisService: mockPaisService),
    ));

    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'Brasil');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    expect(find.text('Brasil'), findsOneWidget);
    expect(find.text('França'), findsNothing);
  });

  testWidgets('04 - Buscar país que não existe', (WidgetTester tester) async {
    when(mockPaisService.listarPaises())
        .thenAnswer((_) async => fakeCountries);

    when(mockPaisService.buscarPaisPorNome('Atlantis'))
        .thenAnswer((_) async => null);

    await tester.pumpWidget(MaterialApp(
      home: CountryListScreen(paisService: mockPaisService),
    ));

    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'Atlantis');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    expect(find.textContaining('não encontrado'), findsOneWidget);
  });

  testWidgets('05 - País com dados incompletos', (WidgetTester tester) async {
    final incompleteCountry = Country(
      name: 'País Desconhecido',
      capital: '',
      region: '',
      population: 0,
      flag: '',
      subregion: ""
    );

    when(mockPaisService.listarPaises())
        .thenAnswer((_) async => [incompleteCountry]);

    await tester.pumpWidget(MaterialApp(
      home: CountryListScreen(paisService: mockPaisService),
    ));

    await tester.pumpAndSettle();

    expect(find.text('País Desconhecido'), findsOneWidget);
  });

  testWidgets('06 - Verifica se listarPaises() foi chamado', (WidgetTester tester) async {
    when(mockPaisService.listarPaises())
        .thenAnswer((_) async => fakeCountries);

    await tester.pumpWidget(MaterialApp(
      home: CountryListScreen(paisService: mockPaisService),
    ));

    await tester.pumpAndSettle();

    verify(mockPaisService.listarPaises()).called(1);
  });

  testWidgets('07 - Simular lentidão da API e verificar Loading', (WidgetTester tester) async {
    when(mockPaisService.listarPaises())
        .thenAnswer((_) async {
          await Future.delayed(const Duration(seconds: 2));
          return fakeCountries;
        });

    await tester.pumpWidget(MaterialApp(
      home: CountryListScreen(paisService: mockPaisService),
    ));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pumpAndSettle();

    expect(find.text('Brasil'), findsOneWidget);
    expect(find.text('França'), findsOneWidget);
  });
}