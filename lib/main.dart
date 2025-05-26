import 'package:flutter/material.dart';
import 'country_list_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Países do Mundo',
      theme: ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.indigo, // Cor principal (pode alterar)
    brightness: Brightness.light,
  ),
  useMaterial3: true,
  appBarTheme: AppBarTheme(
    backgroundColor: ColorScheme.fromSeed(seedColor: Colors.indigo).primary,
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: IconThemeData(color: Colors.white),
  ),
  cardTheme: CardTheme(
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
),
      home: CountryListScreen(),
    );
  }
}