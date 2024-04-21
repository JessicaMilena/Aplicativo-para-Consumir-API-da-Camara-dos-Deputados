import 'dart:convert';

import 'package:camara_dos_deputados/services/client.dart';
import '../models/parliamentarian.dart';
import '../services/exceptions.dart';

abstract class ParliamentarianInterface {
  Future<List<Parliamentarian>> getParliamentarians();
}

class ParliamentarianRepository implements ParliamentarianInterface {
  final HttpInterface client;

  ParliamentarianRepository({
    required this.client,
  });

  @override
  Future<List<Parliamentarian>> getParliamentarians() async {
    final response = await client.get(
      url: 'https://dadosabertos.camara.leg.br/api/v2/deputados',
    );

    if (response.statusCode == 200) {
      final List<Parliamentarian> parliamentarians = [];
      final body = jsonDecode(response.body);

      body['dados'].map((parliamentarian) {
        parliamentarians.add(Parliamentarian.fromMap(parliamentarian));
      }).toList();

      return parliamentarians;
    } else if (response.statusCode == 404) {
      throw NotFoundException('A url informada não foi encontrada');
    } else {
      throw Exception('Error: ${response.statusCode}');
    }
  }
}
//este código implementa um repositório de dados para lidar com informações sobre parlamentares,
// interagindo com uma API que fornece esses dados e 
//tratando possíveis erros que possam ocorrer durante as solicitações HTTP.