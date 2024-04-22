import 'package:flutter/material.dart';
import 'package:camara_dos_deputados/models/parliamentarian.dart';
import 'package:camara_dos_deputados/stores/expense.dart';
import 'package:camara_dos_deputados/stores/occupation.dart';
import 'package:camara_dos_deputados/stores/parliamentarian_details.dart';

import '../repositories/expense.dart';
import '../repositories/occupation.dart';
import '../repositories/parliamentarian_details.dart';
import '../services/client.dart';

class ParliamentarianDetails extends StatefulWidget {
  final Parliamentarian parliamentarian;
  const ParliamentarianDetails({super.key, required this.parliamentarian});

  @override
  State<ParliamentarianDetails> createState() => _ParliamentarianDetailsState();
}

class _ParliamentarianDetailsState extends State<ParliamentarianDetails> {
  final ParliamentarianDetailsStore detailsStore = ParliamentarianDetailsStore(
      repository: ParliamentarianDetailsRepository(
    client: HttpClient(),
  ));

  final ExpenseStore expenseStore = ExpenseStore(
      repository: ExpenseRepository(
    client: HttpClient(),
  ));

  final OccupationStore occupationStore = OccupationStore(
      repository: OccupationRepository(
    client: HttpClient(),
  ));

  String _monthToString(int monthNumber) {
    switch (monthNumber) {
      case 1:
        return 'Janeiro';
      case 2:
        return 'Fevereiro';
      case 3:
        return 'Março';
      case 4:
        return 'Abril';
      case 5:
        return 'Maio';
      case 6:
        return 'Junho';
      case 7:
        return 'Julho';
      case 8:
        return 'Agosto';
      case 9:
        return 'Setembro';
      case 10:
        return 'Outubro';
      case 11:
        return 'Novembro';
      case 12:
        return 'Dezembro';
      default:
        return 'Sem seleção';
    }
  }

  int _selectedYear = 2020;
  int _selectedMonth = 0;

  @override
  void initState() {
    super.initState();
    detailsStore.getParliamentarianDetails(widget.parliamentarian.id);
    expenseStore.getExpenses(widget.parliamentarian.id, 2024, 1);
    occupationStore.getOccupations(widget.parliamentarian.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Detalhes do Deputado',
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: AnimatedBuilder(
        animation: Listenable.merge([
          detailsStore.isLoading,
          detailsStore.state,
          detailsStore.error,
          expenseStore.isLoading,
          expenseStore.state,
          expenseStore.error,
          occupationStore.isLoading,
          occupationStore.state,
          occupationStore.error,
        ]),
        builder: (context, child) {
          if (detailsStore.isLoading.value ||
              expenseStore.isLoading.value ||
              occupationStore.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            );
          }

          int actualYear = DateTime.now().year;

          if (detailsStore.error.value.isNotEmpty ||
              expenseStore.error.value.isNotEmpty ||
              occupationStore.error.value.isNotEmpty) {
            return Center(
              child: Text(detailsStore.error.value +
                  expenseStore.error.value +
                  occupationStore.error.value),
            );
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 200,
                  child: Center(
                    child: Container(
                      width: 200,
                      height: 200,
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.blue,
                              ),
                            ),
                            child: ClipOval(
                              child: Image.network(
                                widget.parliamentarian.photo,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            widget.parliamentarian.name,
                            style: const TextStyle(
                              color: Colors.blue,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                        ),
                        child: const Text(
                          'Detalhes',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: DefaultTextStyle(
                          style: const TextStyle(
                            color: Colors.blue,
                            fontSize: 10,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Nome Civil: ${detailsStore.state.value.civilName}',
                                  ),
                                  Text(
                                    'Nome Eleitoral: ${detailsStore.state.value.nickname}',
                                  ),
                                  Text(
                                    'CPF: ${detailsStore.state.value.cpf}',
                                  ),
                                  Text(
                                    'Data de nascimento: ${detailsStore.state.value.birthDate}',
                                  ),
                                  Text(
                                    'Escolaridade: ${detailsStore.state.value.education}',
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                        ),
                        child: const Text(
                          'Despesas',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: DefaultTextStyle(
                          style: const TextStyle(
                            color: Colors.blue,
                            fontSize: 10,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Selecione o ano e o mês:',
                                  ),
                                  const SizedBox(width: 10),
                                  DropdownButton<int>(
                                    style: const TextStyle(
                                      color: Colors.blue,
                                      fontSize: 10,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                    alignment: Alignment.center,
                                    menuMaxHeight: 300,
                                    underline: Container(
                                      color: Colors.blue,
                                    ),
                                    focusColor: Colors.blue,
                                    dropdownColor: Colors.white,
                                    value: _selectedYear,
                                    items: List<DropdownMenuItem<int>>.generate(
                                        actualYear - 2019, (index) {
                                      return DropdownMenuItem<int>(
                                        value: 2020 + index,
                                        child: Text('${2020 + index}'),
                                      );
                                    }),
                                    onChanged: (int? selectedYear) {
                                      if (selectedYear != null) {
                                        _selectedYear = selectedYear;
                                        expenseStore.getExpenses(
                                            widget.parliamentarian.id,
                                            selectedYear,
                                            _selectedMonth);
                                      }
                                    },
                                  ),
                                  const SizedBox(width: 10),
                                  DropdownButton<int>(
                                    style: const TextStyle(
                                      color: Colors.blue,
                                      fontSize: 10,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                    alignment: Alignment.center,
                                    menuMaxHeight: 300,
                                    underline: Container(
                                      color: Colors.blue,
                                    ),
                                    focusColor: Colors.blue,
                                    dropdownColor: Colors.white,
                                    value: _selectedMonth,
                                    items: List<DropdownMenuItem<int>>.generate(
                                        13, (index) {
                                      return DropdownMenuItem<int>(
                                        value: index,
                                        child: Text(_monthToString(index)),
                                      );
                                    }),
                                    onChanged: (int? selectedMonth) {
                                      if (selectedMonth != null) {
                                        _selectedMonth = selectedMonth;
                                        expenseStore.getExpenses(
                                            widget.parliamentarian.id,
                                            _selectedYear,
                                            selectedMonth);
                                      }
                                    },
                                  ),
                                ],
                              ),
                              Text(
                                'Total: R\$ ${expenseStore.state.value.fold(
                                      0.0,
                                      (previousValue, element) =>
                                          previousValue + element.documentValue,
                                    ).toDouble().toStringAsFixed(2)}',
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 150,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            ValueListenableBuilder(
                              valueListenable: expenseStore.state,
                              builder: (context, state, child) {
                                if (expenseStore.state.value.isEmpty) {
                                  return const Center(
                                    child: Text(
                                      'Nenhuma despesa encontrada',
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 20,
                                      ),
                                    ),
                                  );
                                }
                                return Row(
                                  children: expenseStore.state.value
                                      .map((expense) => Container(
                                            width: 365,
                                            margin: const EdgeInsets.all(4),
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.blue,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Tipo: ${expense.type}',
                                                  style: const TextStyle(
                                                    color: Colors.blue,
                                                    fontSize: 10,
                                                  ),
                                                ),
                                                Text(
                                                  'Fornecedor: ${expense.providerName}',
                                                  style: const TextStyle(
                                                    color: Colors.blue,
                                                    fontSize: 10,
                                                  ),
                                                ),
                                                Text(
                                                  'Valor: ${expense.documentValue}',
                                                  style: const TextStyle(
                                                    color: Colors.blue,
                                                    fontSize: 10,
                                                  ),
                                                ),
                                                Text(
                                                  'Data: ${expense.documentDate}',
                                                  style: const TextStyle(
                                                    color: Colors.blue,
                                                    fontSize: 10,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ))
                                      .toList(),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                        ),
                        child: const Text(
                          'Ocupações',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 100,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            ValueListenableBuilder(
                              valueListenable: occupationStore.state,
                              builder: (context, state, child) {
                                if (occupationStore.state.value.first.title ==
                                    '') {
                                  return Center(
                                    child: Container(
                                      width: 365,
                                      margin: const EdgeInsets.all(4),
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.blue,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: const Text(
                                          'Nenhuma ocupação encontrada',
                                          style: TextStyle(
                                            color: Colors.blue,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }
                                return Row(
                                  children: occupationStore.state.value
                                      .map((occupation) => Container(
                                            width: 365,
                                            margin: const EdgeInsets.all(4),
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.blue,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Nome: ${occupation.title}',
                                                  style: const TextStyle(
                                                    color: Colors.blue,
                                                    fontSize: 10,
                                                  ),
                                                ),
                                                Text(
                                                  'Entidade: ${occupation.entity == '' ? 'Não informado' : occupation.entity}',
                                                  style: const TextStyle(
                                                    color: Colors.blue,
                                                    fontSize: 10,
                                                  ),
                                                ),
                                                Text(
                                                  'Data de início: ${occupation.startYear == 'null' ? 'Não informado' : occupation.startYear}',
                                                  style: const TextStyle(
                                                    color: Colors.blue,
                                                    fontSize: 10,
                                                  ),
                                                ),
                                                Text(
                                                  'Data de fim: ${occupation.startYear == 'null' && occupation.endYear == 'null' ? 'Não Informado' : occupation.endYear == 'null' ? 'Até o momento' : occupation.endYear}',
                                                  style: const TextStyle(
                                                    color: Colors.blue,
                                                    fontSize: 10,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ))
                                      .toList(),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
