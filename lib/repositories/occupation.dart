import 'dart:convert';

import '../models/occupation.dart';
import '../services/client.dart';
import '../services/exceptions.dart';

abstract class OccupationInterface {
  Future<List<Occupation>> getOccupations(int id);
}

class OccupationRepository implements OccupationInterface {
  final HttpInterface client;

  OccupationRepository({required this.client});

  @override
  Future<List<Occupation>> getOccupations(int id) async {
    final response = await client.get(
      url: 'https://dadosabertos.camara.leg.br/api/v2/deputados/$id/ocupacoes',
    );

    if (response.statusCode == 200) {
      final List<Occupation> occupations = [];
      final body = jsonDecode(response.body);

      body['dados'].map((occupation) {
        occupations.add(Occupation.fromMap(occupation));
      }).toList();

      return occupations;
    } else if (response.statusCode == 404) {
      throw NotFoundException('A url informada não foi encontrada');
    } else {
      throw Exception('Error: ${response.statusCode}');
    }
  }
}
//este código implementa um repositório de dados para lidar com
// informações sobre ocupações ou cargos ocupados por parlamentares, 
//interagindo com uma API que fornece esses dados e 
//tratando possíveis erros que possam ocorrer durante as solicitações HTTP.