class Commission {
  final int id;
  final String uri;
  final String title;
  final int legislature;

  late final Map<String, dynamic> details;
  late final List<dynamic> parliamentarians;

  Commission({
    required this.id,
    required this.uri,
    required this.title,
    required this.legislature,
    this.details = const {},
    this.parliamentarians = const [],
  });

  factory Commission.fromMap(Map<String, dynamic> map) {
    return Commission(
      id: map['id'],
      uri: map['uri'],
      title: map['titulo'],
      legislature: map['idLegislatura'],
    );
  }
}
//esse código define uma estrutura básica para representar uma comissão parlamentar,
// permitindo a criação de instâncias da classe Commission a partir 
//de mapas e fornecendo a capacidade de armazenar detalhes adicionais
// e listar os parlamentares associados à comissão.