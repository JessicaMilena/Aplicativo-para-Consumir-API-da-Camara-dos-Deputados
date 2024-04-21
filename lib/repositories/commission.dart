import 'dart:convert';

import '../models/commission.dart';
import '../services/client.dart';
import '../services/exceptions.dart';

abstract class CommissionInterface {
  Future<List<Commission>> getCommissions();
}

class CommissionRepository implements CommissionInterface {
  final HttpInterface client;

  CommissionRepository({required this.client});

  Future<Map<String, dynamic>> getCommissionDetails(int id) async {
    final response = await client.get(
      url: 'https://dadosabertos.camara.leg.br/api/v2/frentes/$id',
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 404) {
      throw NotFoundException('A url informada não foi encontrada');
    } else {
      throw Exception('Error: ${response.statusCode}');
    }
  }

  Future<List<dynamic>> getCommissionParliamentarians(int id) async {
    final response = await client.get(
      url: 'https://dadosabertos.camara.leg.br/api/v2/frentes/$id/membros',
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['dados'];
    } else if (response.statusCode == 404) {
      throw NotFoundException('A url informada não foi encontrada');
    } else {
      throw Exception('Error: ${response.statusCode}');
    }
  }

  @override
  Future<List<Commission>> getCommissions() async {
    final response = await client.get(
      url: 'https://dadosabertos.camara.leg.br/api/v2/frentes',
    );

    if (response.statusCode == 200) {
      final List<Commission> commissions = [];
      final body = jsonDecode(response.body);

      body['dados'].map((commission) {
        commissions.add(Commission.fromMap(commission));
      }).toList();

      return commissions;
    } else if (response.statusCode == 404) {
      throw NotFoundException('A url informada não foi encontrada');
    } else {
      throw Exception('Error: ${response.statusCode}');
    }
  }
}
//este código implementa um repositório de dados para lidar com informações
// sobre comissões parlamentares, interagindo com uma API
// que fornece esses dados e tratando possíveis erros que possam ocorrer durante as solicitações HTTP.