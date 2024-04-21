import 'dart:convert';

import '../models/expense.dart';
import '../services/client.dart';
import '../services/exceptions.dart';

abstract class ExpenseInterface {
  Future<List<Expense>> getExpenses(int id, int year, int month);
}

class ExpenseRepository implements ExpenseInterface {
  final HttpInterface client;

  ExpenseRepository({required this.client});

  @override
  Future<List<Expense>> getExpenses(int id, int year, int month) async {
    final response = await client.get(
      url:
          'https://dadosabertos.camara.leg.br/api/v2/deputados/$id/despesas?ano=&mes=$month',
    );

    if (response.statusCode == 200) {
      final List<Expense> expenses = [];
      final body = jsonDecode(response.body);

      body['dados'].map((expense) {
        expenses.add(Expense.fromMap(expense));
      }).toList();

      return expenses;
    } else if (response.statusCode == 404) {
      throw NotFoundException('A url informada não foi encontrada');
    } else {
      throw Exception('Error: ${response.statusCode}');
    }
  }
}
//este código implementa um repositório de dados para lidar com informações sobre despesas parlamentares,
// interagindo com uma API que fornece esses dados e 
//tratando possíveis erros que possam ocorrer durante as solicitações HTTP.