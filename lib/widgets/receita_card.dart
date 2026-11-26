import 'package:material_ui/material_ui.dart';

import '../models/receita.dart';
import '../theme/tema_app.dart';
import 'botao_favorito.dart';
import 'imagem_receita.dart';

/// Cartão usado na listagem, na pesquisa e nos favoritos.
class ReceitaCard extends StatelessWidget {
  const ReceitaCard({super.key, required this.receita, required this.aoTocar});

  final Receita receita;
  final VoidCallback aoTocar;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: CoresApp.borda),
      ),
      child: InkWell(
        onTap: aoTocar,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ImagemReceita(url: receita.imagem, largura: 100, altura: 100),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text(
                      receita.nome,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: CoresApp.azulPetroleo,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      receita.resumo,
                      style: const TextStyle(
                        fontSize: 12,
                        color: CoresApp.textoSecundario,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          receita.avaliacaoTexto ?? 'Sem avaliação',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: CoresApp.azulPrincipal,
                          ),
                        ),
                        const Spacer(),
                        BotaoFavorito(receita: receita),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}