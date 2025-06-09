import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:paises/country_model.dart';


abstract class PaisService {
  Future<List<Country>> listarPaises();
  Future<Country?> buscarPaisPorNome(String nome);
}

class PaisServiceImpl implements PaisService {
  @override
  Future<List<Country>> listarPaises() async {
    final response = await http.get(Uri.parse('https://restcountries.com/v3.1/independent?status=true&fields=languages,capital,name,flags,population,region,subregion,png'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Country.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao buscar países');
    }
  }

  @override
  Future<Country?> buscarPaisPorNome(String nome) async {
    final response = await http.get(Uri.parse('https://restcountries.com/v3.1/name/$nome'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      if (data.isNotEmpty) {
        return Country.fromJson(data[0]);
      }
      return null;
    } else {
      throw Exception('Erro ao buscar país');
    }
  }
}
