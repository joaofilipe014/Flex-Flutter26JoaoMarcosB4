import 'package:material_ui/material_ui.dart';
import '../controllers/navegacao_controller.dart';
import '../theme/tema_app.dart';

/// Barra inferior "Explorar | Favoritos".
///
/// [voltarAoInicio] = true quando a barra aparece numa tela empilhada
/// (ex.: Pesquisa): ao trocar de aba, fecha a tela e volta para a principal.
class BarraNavegacao extends StatelessWidget {
  const BarraNavegacao({super.key, this.voltarAoInicio = false});

  final bool voltarAoInicio;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: NavegacaoController.abaAtual,
      builder: (context, aba, _) {
        return NavigationBar(
          selectedIndex: aba,
          onDestinationSelected: (novaAba) {
            NavegacaoController.abaAtual.value = novaAba;
            if (voltarAoInicio) {
              Navigator.popUntil(context, (rota) => rota.isFirst);
            }
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.search, color: CoresApp.azulPetroleo),
              label: 'Explorar',
            ),
            NavigationDestination(
              icon: Icon(Icons.favorite_border, color: CoresApp.azulPetroleo),
              selectedIcon: Icon(Icons.favorite, color: CoresApp.coracao),
              label: 'Favoritos',
            ),
          ],
        );
      },
    );
  }
}