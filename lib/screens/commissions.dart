import 'package:flutter/material.dart';

import '../models/commission.dart';
import '../repositories/commission.dart';
import '../stores/commission.dart';
import '../services/client.dart';

class Commissions extends StatefulWidget {
  Commissions({Key? key}) : super(key: key);

  @override
  State<Commissions> createState() => _CommissionsState();
}

class _CommissionsState extends State<Commissions> {
  final CommissionStore store = CommissionStore(
      repository: CommissionRepository(
    client: HttpClient(),
  ));

  String query = '';

  @override
  void initState() {
    super.initState();
    store.getCommissions();
  }

  List<Commission> filterCommissions(List<Commission> commissions) {
    return commissions
        .where((commission) =>
            commission.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Comissões',
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar Comissão...',
                border: InputBorder.none,
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.blue,
                ),
              ),
              style: const TextStyle(color: Colors.black, fontSize: 16),
              onChanged: (value) {
                setState(() {
                  query = value;
                });
              },
            ),
          ),
        ),
      ),
      body: AnimatedBuilder(
        animation: store.isLoading,
        builder: (context, child) {
          if (store.isLoading.value) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            );
          }

          if (store.error.value.isNotEmpty) {
            return Center(
              child: Text(store.error.value),
            );
          }

          final filteredCommissions = filterCommissions(store.state.value);

          return ListView.builder(
            itemCount: filteredCommissions.length,
            itemBuilder: (context, index) {
              final Commission commission = filteredCommissions[index];
              return Card(
                elevation: 4,
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  title: Text(
                    commission.title,
                    style: const TextStyle(color: Colors.black),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          contentPadding: const EdgeInsets.all(16),
                          titleTextStyle: const TextStyle(
                              color: Colors.blue,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                          title: Text(commission.title),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              FutureBuilder<Map<String, dynamic>>(
                                future: store.repository
                                    .getCommissionDetails(commission.id),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.blue),
                                      ),
                                    );
                                  }

                                  if (snapshot.hasError) {
                                    return Center(
                                      child: Text(snapshot.error.toString()),
                                    );
                                  }

                                  final Map<String, dynamic> details =
                                      snapshot.data!;

                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Título: ${details['dados']['titulo']}',
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'Telefone: ${details['dados']['telefone']}',
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'Email: ${details['dados']['email']}',
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                              SizedBox(height: 16),
                              FutureBuilder<List<dynamic>>(
                                future: store.repository
                                    .getCommissionParliamentarians(
                                        commission.id),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.blue),
                                      ),
                                    );
                                  }

                                  if (snapshot.hasError) {
                                    return Center(
                                      child: Text(snapshot.error.toString()),
                                    );
                                  }

                                  final List<dynamic> parliamentarians =
                                      snapshot.data!;

                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Membros',
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      for (var parliamentarian
                                          in parliamentarians)
                                        ListTile(
                                          leading: CircleAvatar(
                                            backgroundImage: NetworkImage(
                                              parliamentarian['urlFoto'],
                                            ),
                                          ),
                                          title: Text(parliamentarian['nome']),
                                          subtitle: Text(
                                              '${parliamentarian['titulo']} - ${parliamentarian['siglaPartido']} - ${parliamentarian['siglaUf']}'),
                                        ),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                          actions: [
                            TextButton.icon(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(Icons.close, color: Colors.blue),
                              label: Text(
                                'Fechar',
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
