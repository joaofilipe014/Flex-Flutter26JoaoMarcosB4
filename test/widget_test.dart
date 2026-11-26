import 'dart:convert';

import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:projetoreceita/data/receita_repositorio.dart';
import 'package:projetoreceita/main.dart';
import 'package:projetoreceita/screens/detalhes_tela.dart';
import 'package:projetoreceita/screens/pesquisa_tela.dart';
import 'package:projetoreceita/utils/validacao_pesquisa.dart';

import 'receitas_exemplo.dart';
/// Servidor falso que responde como a DummyJSON, sem usar a internet.
MockClient apiFalsa() {
  return MockClient((requisicao) async {
    var receitas = receitasExemplo;
    if (requisicao.url.path == '/recipes/search') {
      final termo = requisicao.url.queryParameters['q']!.toLowerCase();
      receitas = receitas
          .where((r) => (r['name'] as String).toLowerCase().contains(termo))
          .toList();
    }
    return http.Response.bytes(
      utf8.encode(jsonEncode({'recipes': receitas, 'total': receitas.length})),
      200,
    );
  });
}

void main() {
  setUp(() => ReceitaRepositorio.clientePadrao = apiFalsa());

  test('normaliza espaços da consulta', () {
    expect(normalizarConsulta('  bolo   de  chocolate '), 'bolo de chocolate');
    expect(validarConsulta('    '), mensagemConsultaVazia);
    expect(validarConsulta(' pizza '), isNull);
  });

  test('repositório monta a URL da API e converte o JSON', () async {
    late Uri urlPedida;
    final repositorio = ReceitaRepositorio(
      cliente: MockClient((requisicao) async {
        urlPedida = requisicao.url;
        return http.Response.bytes(
          utf8.encode(jsonEncode({'recipes': receitasExemplo})),
          200,
        );
      }),
    );

    final receitas = await repositorio.pesquisarPorNome('chicken alfredo');

    expect(urlPedida.host, 'dummyjson.com');
    expect(urlPedida.path, '/recipes/search');
    expect(urlPedida.queryParameters['q'], 'chicken alfredo');
    expect(receitas.first.nome, 'Classic Margherita Pizza');
  });

  test('repositório avisa quando a API responde com erro', () async {
    final repositorio = ReceitaRepositorio(
      cliente: MockClient((_) async => http.Response('erro', 500)),
    );

    expect(repositorio.buscarTodas(), throwsA(isA<ReceitaApiException>()));
  });

  testWidgets('página inicial mostra nome, campo, botão e lista', (
      tester,
      ) async {
    await tester.pumpWidget(const CozinhaDeBolsoApp());
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('Cozinha de Bolso'), findsWidgets);
    expect(find.text('Pesquisar receitas'), findsOneWidget);
    expect(find.byKey(const Key('campo-busca-inicio')), findsOneWidget);
    expect(find.byKey(const Key('botao-busca-inicio')), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Classic Margherita Pizza'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Classic Margherita Pizza'), findsOneWidget);
  });

  testWidgets('mostra erro e "Tentar novamente" quando a API falha', (
      tester,
      ) async {
    ReceitaRepositorio.clientePadrao = MockClient(
          (_) async => http.Response('erro', 500),
    );

    await tester.pumpWidget(const CozinhaDeBolsoApp());
    await tester.pump(const Duration(seconds: 1));

    await tester.scrollUntilVisible(
      find.text('Tentar novamente'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Não foi possível carregar as receitas.'), findsOneWidget);
  });

  testWidgets('recusa consulta vazia e pesquisa termo válido com espaços', (
      tester,
      ) async {
    await tester.pumpWidget(const CozinhaDeBolsoApp());
    await tester.pump(const Duration(seconds: 1));

    final campo = find.byKey(const Key('campo-busca-inicio'));
    final botao = find.byKey(const Key('botao-busca-inicio'));

    await tester.enterText(campo, '    ');
    await tester.ensureVisible(botao);
    await tester.tap(botao);
    await tester.pumpAndSettle();

    expect(find.text(mensagemConsultaVazia), findsOneWidget);
    expect(find.byType(PesquisaTela), findsNothing); // não navegou

    await tester.enterText(campo, '   pizza   ');
    await tester.ensureVisible(botao);
    await tester.tap(botao);
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 1));

    expect(find.byType(PesquisaTela), findsOneWidget);
    expect(find.text('Resultados para “pizza”'), findsOneWidget);
    expect(find.text('Classic Margherita Pizza'), findsOneWidget);
  });
  testWidgets('dois toques rápidos abrem a pesquisa uma vez só', (
      tester,
      ) async {
    await tester.pumpWidget(const CozinhaDeBolsoApp());
    await tester.pump(const Duration(seconds: 1));

    final botao = find.byKey(const Key('botao-busca-inicio'));
    await tester.enterText(
      find.byKey(const Key('campo-busca-inicio')),
      'pizza',
    );
    await tester.ensureVisible(botao);
    await tester.tap(botao);
    await tester.tap(botao, warnIfMissed: false);
    await tester.pumpAndSettle();

    expect(find.byType(PesquisaTela, skipOffstage: false), findsOneWidget);
  });

  testWidgets('detalhes mostram ingredientes, passos e tipo de refeição', (
      tester,
      ) async {
    await tester.pumpWidget(const CozinhaDeBolsoApp());
    await tester.pump(const Duration(seconds: 1));

    final cartao = find.text('Chocolate Chip Cookies');
    await tester.scrollUntilVisible(
      cartao,
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(cartao);
    await tester.pumpAndSettle();

    expect(find.byType(DetalhesTela), findsOneWidget);
    expect(find.text('Snack'), findsOneWidget);
    expect(find.text('Dessert'), findsOneWidget);
    expect(find.text('Ingredientes'), findsOneWidget);

    // O modo de preparo fica mais abaixo: rola a tela até ele.
    await tester.scrollUntilVisible(
      find.text('Modo de preparo'),
      300,
      scrollable: find.byType(Scrollable).last,
    );
    expect(find.text('Modo de preparo'), findsOneWidget);
  });
}