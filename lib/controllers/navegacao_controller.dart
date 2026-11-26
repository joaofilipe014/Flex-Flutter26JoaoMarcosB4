import 'package:flutter/foundation.dart';

/// Guarda qual aba da barra inferior está selecionada.
class NavegacaoController {
  NavegacaoController._();

  static const int explorar = 0;
  static const int favoritos = 1;

  static final ValueNotifier<int> abaAtual = ValueNotifier<int>(explorar);
}