import 'package:flutter/material.dart';
import 'package:paises/country_model.dart';
import 'pais_service.dart';

class CountryListScreen extends StatefulWidget {
  final PaisService paisService;

  const CountryListScreen({Key? key, required this.paisService}) : super(key: key);

  @override
  State<CountryListScreen> createState() => _CountryListScreenState();
}

class _CountryListScreenState extends State<CountryListScreen> {
  late Future<List<Country>> _futureCountries;

  @override
  void initState() {
    super.initState();
    _futureCountries = widget.paisService.listarPaises();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Países do Mundo'),
      ),
      body: FutureBuilder<List<Country>>(
        future: _futureCountries,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar países'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Nenhum país encontrado'));
          } else {
            final countries = snapshot.data!;
            return ListView.builder(
              itemCount: countries.length,
              itemBuilder: (context, index) {
                final country = countries[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    leading: country.flag.isNotEmpty
                        ? Image.network(country.flag, width: 50, height: 30, fit: BoxFit.cover)
                        : Container(
                            width: 50,
                            height: 30,
                            color: Colors.grey,
                            alignment: Alignment.center,
                            child: const Text('N/A', style: TextStyle(color: Colors.white)),
                          ),
                    title: Text(country.name),
                    subtitle: Text(country.capital.isNotEmpty ? country.capital : 'Informação não disponível'),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
