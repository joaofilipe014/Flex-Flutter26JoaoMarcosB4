import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/receita.dart';

/// Erro mostrado quando a API não responde como esperado.
class ReceitaApiException implements Exception {
  const ReceitaApiException(this.mensagem);

  final String mensagem;

  @override
  String toString() => mensagem;
}

/// Ponto único de acesso às receitas da API DummyJSON Recipes.
///
///   Listagem: GET https://dummyjson.com/recipes
///   Pesquisa: GET https://dummyjson.com/recipes/search?q=termo
///
/// A tela de detalhes reaproveita o objeto completo que já veio na
/// listagem/pesquisa (a API devolve todos os campos), sem nova requisição.
class ReceitaRepositorio {
  ReceitaRepositorio({http.Client? cliente})
      : _cliente = cliente ?? clientePadrao;

  /// Cliente HTTP usado pelas telas. Nos testes ele é trocado por um
  /// MockClient, para os testes não dependerem da internet.
  static http.Client clientePadrao = http.Client();

  static const String _servidor = 'dummyjson.com';
  static const Duration _tempoLimite = Duration(seconds: 15);

  final http.Client _cliente;

  /// Busca todas as receitas (limit=0 faz a API devolver todas).
  Future<List<Receita>> buscarTodas() {
    return _buscarLista(Uri.https(_servidor, '/recipes', {'limit': '0'}));
  }

  /// Pesquisa receitas pelo nome. O Uri.https já codifica espaços e
  /// acentos do termo, ex.: "bolo de" -> "bolo%20de".
  Future<List<Receita>> pesquisarPorNome(String termo) {
    return _buscarLista(
      Uri.https(_servidor, '/recipes/search', {'q': termo, 'limit': '0'}),
    );
  }

  Future<List<Receita>> _buscarLista(Uri endereco) async {
    final http.Response resposta;
    try {
      resposta = await _cliente.get(endereco).timeout(_tempoLimite);
    } catch (_) {
      // Sem internet, servidor fora do ar ou demorou demais.
      throw const ReceitaApiException('Não foi possível conectar à API.');
    }

    if (resposta.statusCode != 200) {
      throw ReceitaApiException(
        'A API respondeu com erro ${resposta.statusCode}.',
      );
    }

    final Object? corpo;
    try {
      corpo = jsonDecode(utf8.decode(resposta.bodyBytes));
    } on FormatException {
      throw const ReceitaApiException('A API devolveu dados inválidos.');
    }

    if (corpo is! Map<String, dynamic> || corpo['recipes'] is! List) {
      throw const ReceitaApiException('A API devolveu dados inválidos.');
    }

    final receitas = <Receita>[];
    for (final item in corpo['recipes'] as List) {
      if (item is! Map<String, dynamic>) continue;
      try {
        receitas.add(Receita.fromJson(item));
      } on FormatException {
        // Ignora só a receita com problema e mantém as outras.
      }
    }
    return receitas;
  }
}