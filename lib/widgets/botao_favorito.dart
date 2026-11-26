import 'package:material_ui/material_ui.dart';
import '../controllers/favoritos_controller.dart';
import '../models/receita.dart';
import '../theme/tema_app.dart';

/// Coração que adiciona/remove a receita dos favoritos.
class BotaoFavorito extends StatelessWidget {
  const BotaoFavorito({super.key, required this.receita, this.tamanho = 24});

  final Receita receita;
  final double tamanho;

  @override
  Widget build(BuildContext context) {
    final favoritos = FavoritosController.instancia;

    return ListenableBuilder(
      listenable: favoritos,
      builder: (context, _) {
        final favorita = favoritos.ehFavorita(receita);
        return IconButton(
          visualDensity: VisualDensity.compact,
          tooltip: favorita
              ? 'Remover dos favoritos'
              : 'Adicionar aos favoritos',
          onPressed: () => favoritos.alternar(receita),
          icon: Icon(
            favorita ? Icons.favorite : Icons.favorite_border,
            // Sem favorito, usa a cor do lugar onde está
            // (branco na barra azul, cinza-azulado nos cartões).
            color: favorita ? CoresApp.coracao : null,
            size: tamanho,
          ),
        );
      },
    );
  }
}