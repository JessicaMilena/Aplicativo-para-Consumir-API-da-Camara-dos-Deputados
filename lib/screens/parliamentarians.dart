import 'package:flutter/material.dart';

import 'package:camara_dos_deputados/repositories/parliamentarian.dart';
import 'package:camara_dos_deputados/stores/parliamentarian.dart';

import '../models/parliamentarian.dart';
import '../routes/router.dart' as routes;
import '../services/client.dart';

class Parliamentarians extends StatefulWidget {
  const Parliamentarians({Key? key});

  @override
  State<Parliamentarians> createState() => _ParliamentariansState();
}

class _ParliamentariansState extends State<Parliamentarians> {
  final ParliamentarianStore store = ParliamentarianStore(
    repository: ParliamentarianRepository(
      client: HttpClient(),
    ),
  );

  String query = '';

  @override
  void initState() {
    super.initState();
    store.getParliamentarians();
  }

  List<Parliamentarian> filterParliamentarians(
      List<Parliamentarian> parliamentarians) {
    return parliamentarians
        .where((parliamentarian) =>
            parliamentarian.name.toLowerCase().contains(query.toLowerCase()) ||
            parliamentarian.party.toLowerCase().contains(query.toLowerCase()) ||
            parliamentarian.uf.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Deputados',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Pesquisar deputados...',
                hintStyle: const TextStyle(color: Colors.white),
                prefixIcon: const Icon(Icons.search, color: Colors.white),
                filled: true,
                fillColor: Colors.blue[700], // Alterado para a cor correta
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
              style: const TextStyle(color: Colors.white),
              onChanged: (value) => setState(() {
                query = value;
              }),
            ),
          ),
        ),
      ),
      body: AnimatedBuilder(
        animation: Listenable.merge([
          store.isLoading,
          store.state,
          store.error,
        ]),
        builder: (context, child) {
          if (store.isLoading.value) {
            return const Center(
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

          if (store.state.value.isEmpty) {
            return const Center(
              child: Text('Nenhum deputado encontrado.'),
            );
          }

          final filteredParliamentarians =
              filterParliamentarians(store.state.value);

          return ListView.builder(
            itemCount: filteredParliamentarians.length,
            itemBuilder: (context, index) {
              final parliamentarian = filteredParliamentarians[index];
              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    routes.parliamentarian,
                    arguments: parliamentarian,
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(parliamentarian.photo),
                      radius: 25,
                    ),
                    title: Text(
                      parliamentarian.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${parliamentarian.party} - ${parliamentarian.uf}',
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
