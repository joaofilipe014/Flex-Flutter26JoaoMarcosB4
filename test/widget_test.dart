import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../lib/main.dart';

void main() {
  testWidgets('MyApp exibe a tela inicial do Cozinha de Bolso',
          (WidgetTester tester) async {
        await tester.pumpWidget(const CozinhaDeBolsoApp());

        expect(find.text('Cozinha de Bolso'), findsOneWidget);
        expect(find.text('Pesquisar receitas'), findsOneWidget);
        expect(find.byKey(const Key('campo-pesquisa')), findsOneWidget);
        expect(find.byKey(const Key('botao-pesquisar')), findsOneWidget);
      });

  testWidgets('recusa pesquisa vazia ou com apenas espaços e aceita termo válido',
          (WidgetTester tester) async {
        await tester.pumpWidget(const CozinhaDeBolsoApp());

        final campo = find.byKey(const Key('campo-pesquisa'));
        final botao = find.byKey(const Key('botao-pesquisar'));

        await tester.enterText(campo, '   ');
        await tester.ensureVisible(botao);
        await tester.tap(botao);
        await tester.pumpAndSettle();

        expect(
          find.text(
            'Digite o nome de uma receita antes de pesquisar. Ex.: bolo de cenoura.',
          ),
          findsOneWidget,
        );
        expect(find.text('Pesquisa recebida'), findsNothing);

        await tester.enterText(campo, '  bolo   de chocolate  ');
        await tester.tap(botao);
        await tester.pumpAndSettle();

        expect(find.text('Pesquisa recebida'), findsOneWidget);
        expect(find.text('bolo de chocolate'), findsOneWidget);
        expect(find.text('  bolo   de chocolate  '), findsNothing);
      });
}