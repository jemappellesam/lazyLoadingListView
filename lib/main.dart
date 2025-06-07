import 'package:flutter/material.dart';
import 'country_list_screen.dart';
import 'pais_service.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final PaisService paisService = PaisServiceImpl();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Países do Mundo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          backgroundColor: ColorScheme.fromSeed(seedColor: Colors.indigo).primary,
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      home: CountryListScreen(paisService: paisService),
    );
  }
}
