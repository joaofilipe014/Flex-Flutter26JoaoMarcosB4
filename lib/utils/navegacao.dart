import 'package:material_ui/material_ui.dart';

/// Telas que já estão com outra tela aberta por cima.
final Set<Route<dynamic>> _telasOcupadas = {};

/// Abre [tela] por cima da tela atual.
///
/// Enquanto a tela aberta não for fechada, novos toques na tela de origem
/// são ignorados. Assim, dois toques rápidos não abrem a mesma tela duas
/// vezes (RF06). Cada tela tem a sua trava, então a Pesquisa ainda consegue
/// abrir os Detalhes.
Future<void> abrirTela(BuildContext context, Widget tela) async {
  final origem = ModalRoute.of(context);
  if (origem != null && !_telasOcupadas.add(origem)) return;

  try {
    await Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (_) => tela),
    );
  } finally {
    _telasOcupadas.remove(origem);
  }
}