/// Representa uma receita no formato da API DummyJSON Recipes.
class Receita {
  const Receita({
    required this.id,
    required this.nome,
    this.imagem,
    this.ingredientes = const [],
    this.instrucoes = const [],
    this.tempoPreparo,
    this.tempoCozimento,
    this.porcoes,
    this.avaliacao,
    this.dificuldade,
    this.cozinha,
    this.tiposRefeicao = const [],
  });

  final int id;
  final String nome;
  final String? imagem;
  final List<String> ingredientes;
  final List<String> instrucoes;
  final int? tempoPreparo;
  final int? tempoCozimento;
  final int? porcoes;
  final num? avaliacao;
  final String? dificuldade;
  final String? cozinha;
  final List<String> tiposRefeicao;

  /// Converte o JSON da API conferindo o tipo de cada campo.
  factory Receita.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    if (id is! num) {
      throw const FormatException('Receita sem id válido.');
    }

    return Receita(
      id: id.toInt(),
      nome: _texto(json['name']) ?? 'Receita sem nome',
      imagem: _texto(json['image']),
      ingredientes: _listaDeTextos(json['ingredients']),
      instrucoes: _listaDeTextos(json['instructions']),
      tempoPreparo: _inteiro(json['prepTimeMinutes']),
      tempoCozimento: _inteiro(json['cookTimeMinutes']),
      porcoes: _inteiro(json['servings']),
      avaliacao: json['rating'] is num ? json['rating'] as num : null,
      dificuldade: _texto(json['difficulty']),
      cozinha: _texto(json['cuisine']),
      tiposRefeicao: _listaDeTextos(json['mealType']),
    );
  }

  /// Só soma quando os dois tempos existem, para não trocar ausência por zero.
  int? get tempoTotal {
    if (tempoPreparo == null || tempoCozimento == null) return null;
    return tempoPreparo! + tempoCozimento!;
  }

  String? get avaliacaoTexto {
    if (avaliacao == null) return null;
    return '${avaliacao!.toStringAsFixed(1).replaceAll('.', ',')} / 5';
  }

  String? get dificuldadeTexto {
    return switch (dificuldade) {
      'Easy' => 'Fácil',
      'Medium' => 'Médio',
      'Hard' => 'Difícil',
      null => null,
      String outra => outra,
    };
  }

  /// Texto curto do cartão, ex.: "35 min • Fácil".
  String get resumo {
    final partes = [
      tempoTotal != null ? '$tempoTotal min' : 'Tempo não informado',
      ?dificuldadeTexto, // o "?" só inclui se não for nulo
    ];
    return partes.join(' • ');
  }

  static String? _texto(Object? valor) {
    if (valor is String && valor.trim().isNotEmpty) return valor.trim();
    return null;
  }

  static int? _inteiro(Object? valor) => valor is num ? valor.toInt() : null;

  static List<String> _listaDeTextos(Object? valor) {
    if (valor is! List) return const [];
    return valor.whereType<String>().toList();
  }
}