import 'package:material_ui/material_ui.dart';

import '../controllers/favoritos_controller.dart';
import '../models/receita.dart';
import '../theme/tema_app.dart';
import '../widgets/botao_favorito.dart';
import '../widgets/imagem_receita.dart';
import '../widgets/info_resumo.dart';

/// Tela "Receita": ingredientes, modo de preparo e dados úteis.
class DetalhesTela extends StatelessWidget {
  const DetalhesTela({super.key, required this.receita});

  final Receita receita;

  @override
  Widget build(BuildContext context) {
    final subtitulo = [
      receita.cozinha,
      receita.dificuldadeTexto,
      receita.avaliacaoTexto,
    ].whereType<String>().join('  •  ');

    final porcoes = receita.porcoes;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Receita', style: EstilosApp.tituloBarra),
        actions: [
          BotaoFavorito(receita: receita, tamanho: 28),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
          children: [
            ImagemReceita(
              url: receita.imagem,
              largura: double.infinity,
              altura: 200,
              raio: 16,
              tamanhoIcone: 56,
            ),
            const SizedBox(height: 20),
            Text(receita.nome, style: EstilosApp.titulo),
            if (subtitulo.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(subtitulo, style: EstilosApp.descricao),
            ],
            // mealType é uma lista: uma receita pode ter vários tipos.
            if (receita.tiposRefeicao.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final tipo in receita.tiposRefeicao)
                    Chip(
                      avatar: const Icon(
                        Icons.restaurant,
                        size: 16,
                        color: CoresApp.azulPetroleo,
                      ),
                      label: Text(tipo),
                      labelStyle: const TextStyle(
                        fontSize: 12,
                        color: CoresApp.azulPetroleo,
                      ),
                      backgroundColor: CoresApp.azulClaro,
                      side: BorderSide.none,
                      visualDensity: VisualDensity.compact,
                    ),
                ],
              ),
            ],
            const SizedBox(height: 20),
            ListenableBuilder(
              listenable: FavoritosController.instancia,
              builder: (context, _) {
                final favorita = FavoritosController.instancia.ehFavorita(
                  receita,
                );
                return Row(
                  children: [
                    Expanded(
                      child: InfoResumo(
                        valor: receita.tempoTotal != null
                            ? '${receita.tempoTotal} min'
                            : '—',
                        rotulo: receita.tempoTotal != null
                            ? 'tempo total'
                            : 'tempo não informado',
                      ),
                    ),
                    if (porcoes != null && porcoes > 0) ...[
                      const SizedBox(width: 8),
                      Expanded(
                        child: InfoResumo(valor: '$porcoes', rotulo: 'porções'),
                      ),
                    ],
                    const SizedBox(width: 8),
                    Expanded(
                      child: InfoResumo(
                        valor: favorita ? 'Salva' : 'Não salva',
                        rotulo: favorita ? 'nos favoritos' : 'toque no coração',
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 28),
            const Text('Ingredientes', style: EstilosApp.subtitulo),
            const SizedBox(height: 12),
            if (receita.ingredientes.isEmpty)
              const Text(
                'Ingredientes não informados.',
                style: EstilosApp.descricao,
              )
            else
              for (final ingrediente in receita.ingredientes)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 7, right: 10),
                        child: CircleAvatar(
                          radius: 3,
                          backgroundColor: CoresApp.azulPrincipal,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          ingrediente,
                          style: const TextStyle(
                            fontSize: 15,
                            color: CoresApp.azulPetroleo,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            const SizedBox(height: 24),
            const Text('Modo de preparo', style: EstilosApp.subtitulo),
            const SizedBox(height: 12),
            if (receita.instrucoes.isEmpty)
              const Text(
                'Modo de preparo não informado.',
                style: EstilosApp.descricao,
              )
            else
              for (final (indice, passo) in receita.instrucoes.indexed)
                Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 13,
                        backgroundColor: CoresApp.azulPrincipal,
                        child: Text(
                          '${indice + 1}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          passo,
                          style: const TextStyle(
                            fontSize: 15,
                            height: 1.4,
                            color: CoresApp.azulPetroleo,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            const SizedBox(height: 16),
            const Text(
              'Role para ler todos os ingredientes e passos.',
              style: TextStyle(fontSize: 12, color: CoresApp.textoSecundario),
            ),
          ],
        ),
      ),
    );
  }
}