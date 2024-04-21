class Occupation {
  final String title;
  final String entity;
  final String entityUf;
  final String entityCountry;
  final String startYear;
  final String endYear;

  Occupation({
    required this.title,
    required this.entity,
    required this.entityUf,
    required this.entityCountry,
    required this.startYear,
    required this.endYear,
  });

  factory Occupation.fromMap(Map<String, dynamic> map) {
    return Occupation(
      title: map['titulo'] ?? '',
      entity: map['entidade'] ?? '',
      entityUf: map['entidadeUF'] ?? '',
      entityCountry: map['entidadePais'] ?? '',
      endYear: map['anoFim'].toString(),
      startYear: map['anoInicio'].toString(),
    );
  }
}
//esse código define uma estrutura básica para representar uma ocupação ou cargo,
// permitindo a criação de instâncias da classe Occupation a partir de mapas e
// fornecendo métodos para acessar e manipular os dados associados a essa ocupação.