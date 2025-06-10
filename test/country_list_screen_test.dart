import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:paises/country_model.dart';
import 'package:paises/pais_service.dart';
import 'package:flutter/material.dart';
import 'country_list_screen_test.mocks.dart';
import 'package:paises/country_list_screen.dart';
import 'package:network_image_mock/network_image_mock.dart';



@GenerateMocks([PaisService])
void main() {
  late MockPaisService mockPaisService;

    setUp(() {
    mockPaisService = MockPaisService();
  });

  /// Cenário 01 - Listagem bem-sucedida
  /// Verifica se a lista é retornada e exibida corretamente.
 test('Cenário 01 – Listagem bem-sucedida', () async {
    final countries = [
      Country(
        name: 'Brasil',
        capital: 'Brasília',
        population: 21000000,
        region: 'America Latina',
        flag: 'https://flagcdn.com/w320/br.png',
        subregion: 'America do Sul'
      ),
    ];

    when(mockPaisService.listarPaises()).thenAnswer((_) async => countries);

    final result = await mockPaisService.listarPaises();

    expect(result.isNotEmpty, true);
    expect(result.first.name, 'Brasil');
    expect(result.first.capital, 'Brasília');
    expect(result.first.flag, 'https://flagcdn.com/w320/br.png');

  });


// Cenário 2 - Erro na requisição de países
  test('Cenário 02 – Erro na requisição de países lança exceção', () async {
    when(mockPaisService.listarPaises()).thenThrow(Exception('Erro ao buscar países'));

    expect(() async => await mockPaisService.listarPaises(), throwsException);
  });



//Busca país por nome com resultaado
    test('Cenário 03 – Busca de país por nome com resultado', () async {
    final country = Country(
       name: 'Brasil',
        capital: 'Brasília',
        population: 213000000,
        region: 'America Latina',
        flag: 'https://flagcdn.com/w320/br.png',
        subregion: 'America do Sul'
    );

    when(mockPaisService.buscarPaisPorNome('Brasil')).thenAnswer((_) async => country);

    final result = await mockPaisService.buscarPaisPorNome('Brasil');

    expect(result, isNotNull);
    expect(result!.name, 'Brasil');
    expect(result.capital, 'Brasília');
    expect(result.population, 213000000);
    expect(result.flag, 'https://flagcdn.com/w320/br.png');
  });

  // Cenário 04 - Busca de país por nome com resultado vazio
   test('Cenário 04 – Busca de país por nome com resultado vazio', () async {
    when(mockPaisService.buscarPaisPorNome('PaísInexistente')).thenAnswer((_) async => null);

    final result = await mockPaisService.buscarPaisPorNome('PaísInexistente');

  
    expect(result, isNull);
  });

  // Cenário 05 - País com dados incompletos

   test('Cenário 05 – País com dados incompletos', () async {
    final incompleteCountry = Country(
   name: 'Brasil',
        capital: '',
        population: 21000000,
        region: 'America Latina',
        flag: '',
        subregion: 'America do Sul'
    );

    when(mockPaisService.buscarPaisPorNome('PaísSemCapital')).thenAnswer((_) async => incompleteCountry);

    final result = await mockPaisService.buscarPaisPorNome('PaísSemCapital');

    expect(result, isNotNull);
    expect(result!.name, 'Brasil');
    expect(result.capital, isEmpty);
    expect(result.flag, isEmpty); 

    

 
  });

   // Cenário 06 - verificar chamada ao método
    test('Cenário 06 – Verificar chamada ao método listarPaises()', () async {
    when(mockPaisService.listarPaises()).thenAnswer((_) async => []);

    await mockPaisService.listarPaises();

    verify(mockPaisService.listarPaises()).called(1);
  });

    //cenários opcionais
  testWidgets('Mostra loading e depois lista de países', (WidgetTester tester) async {
    when(mockPaisService.listarPaises()).thenAnswer(
      (_) => Future.delayed(Duration(seconds: 1), () => [
        Country(name: 'Brasil',
        capital: 'Brasília',
        population: 21000000,
        region: 'America Latina',
        flag: 'https://flagcdn.com/w320/br.png',
        subregion: 'America do Sul'),
      ]),
    );

    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(MaterialApp(home: CountryListScreen(paisService: mockPaisService)));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pump(Duration(seconds: 1)); 

      expect(find.text('Brasil'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });
  });

}



  
