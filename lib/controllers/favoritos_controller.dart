import 'package:flutter/foundation.dart';

import '../models/receita.dart';

/// Única fonte de verdade dos favoritos (em memória, durante a sessão).
/// As telas escutam este objeto com ListenableBuilder.
class FavoritosController extends ChangeNotifier {
  FavoritosController._();

  static final FavoritosController instancia = FavoritosController._();

  // A chave é o id da receita, então não existe favorito duplicado.
  final Map<int, Receita> _favoritos = {};

  List<Receita> get receitas => _favoritos.values.toList();

  bool ehFavorita(Receita receita) => _favoritos.containsKey(receita.id);

  void alternar(Receita receita) {
    if (ehFavorita(receita)) {
      _favoritos.remove(receita.id);
    } else {
      _favoritos[receita.id] = receita;
    }
    notifyListeners();
  }
}