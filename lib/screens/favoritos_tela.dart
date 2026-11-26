import 'package:material_ui/material_ui.dart';

import '../controllers/favoritos_controller.dart';
import '../controllers/navegacao_controller.dart';
import '../models/receita.dart';
import '../theme/tema_app.dart';
import '../utils/navegacao.dart';
import '../widgets/estado_mensagem.dart';
import '../widgets/receita_card.dart';
import 'detalhes_tela.dart';

/// Aba "Favoritos": receitas marcadas nesta sessão.
class FavoritosTela extends StatelessWidget {
  const FavoritosTela({super.key});

  void _abrirDetalhes(BuildContext context, Receita receita) {
    abrirTela(context, DetalhesTela(receita: receita));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.restaurant_menu, size: 25),
            SizedBox(width: 10),
            Text('Cozinha de Bolso'),
          ],
        ),
      ),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: FavoritosController.instancia,
          builder: (context, _) {
            final favoritos = FavoritosController.instancia.receitas;

            if (favoritos.isEmpty) {
              return ListView(
                padding: const EdgeInsets.fromLTRB(20, 72, 20, 24),
                children: [
                  EstadoMensagem(
                    icone: const Icon(
                      Icons.favorite_border,
                      size: 44,
                      color: CoresApp.azulPetroleo,
                    ),
                    titulo: 'Nenhum favorito',
                    mensagem:
                    'Marque uma receita como favorita para encontrá-la aqui.',
                    textoBotao: 'Explorar receitas',
                    aoPressionarBotao: () =>
                    NavegacaoController.abaAtual.value =
                        NavegacaoController.explorar,
                  ),
                ],
              );
            }

            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
              children: [
                const Text('Favoritos', style: EstilosApp.titulo),
                const SizedBox(height: 8),
                const Text(
                  'Receitas salvas nesta sessão.',
                  style: EstilosApp.descricao,
                ),
                const SizedBox(height: 24),
                for (final receita in favoritos)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: ReceitaCard(
                      receita: receita,
                      aoTocar: () => _abrirDetalhes(context, receita),
                    ),
                  ),
                const SizedBox(height: 24),
                const Text(
                  'Toque no coração para remover.',
                  style: EstilosApp.descricao,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}