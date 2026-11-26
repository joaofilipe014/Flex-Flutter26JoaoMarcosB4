import 'package:material_ui/material_ui.dart';

import '../theme/tema_app.dart';

/// "Esqueleto" mostrado enquanto as receitas carregam.
class CarregandoLista extends StatelessWidget {
  const CarregandoLista({super.key, this.mensagem = 'Carregando receitas…'});

  final String mensagem;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: mensagem,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < 2; i++) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  _barra(largura: 96, altura: 100),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _barra(altura: 12),
                        const SizedBox(height: 12),
                        _barra(largura: 120, altura: 12),
                        const SizedBox(height: 28),
                        _barra(largura: 80, altura: 10),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
          const SizedBox(height: 12),
          Center(child: Text(mensagem, style: EstilosApp.descricao)),
        ],
      ),
    );
  }

  Widget _barra({double? largura, required double altura}) {
    return Container(
      width: largura,
      height: altura,
      decoration: BoxDecoration(
        color: const Color(0xFFE4E7E0),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}