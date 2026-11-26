import 'package:material_ui/material_ui.dart';

import '../controllers/navegacao_controller.dart';
import '../widgets/barra_navegacao.dart';
import 'explorar_tela.dart';
import '../screens/favoritos_tela.dart';

/// Tela base com as abas Explorar e Favoritos.
/// O IndexedStack mantém o estado de cada aba ao trocar entre elas.
class TelaPrincipal extends StatelessWidget {
  const TelaPrincipal({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: NavegacaoController.abaAtual,
      builder: (context, aba, _) {
        return Scaffold(
          body: IndexedStack(
            index: aba,
            children: const [ExplorarTela(), FavoritosTela()],
          ),
          bottomNavigationBar: const BarraNavegacao(),
        );
      },
    );
  }
}