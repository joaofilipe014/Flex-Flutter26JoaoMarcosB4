import 'package:material_ui/material_ui.dart';

/// Cores do Cozinha de Bolso (tons de azul do projeto original).
class CoresApp {
  CoresApp._();

  static const Color azulPetroleo = Color(0xFF164E63);
  static const Color azulPrincipal = Color(0xFF0E7490);
  static const Color azulClaro = Color(0xFFE0F2F7);
  static const Color azulDestaque = Color(0xFFA5D8E8);
  static const Color fundo = Color(0xFFF1F5F9);
  static const Color textoSecundario = Color(0xFF475569);
  static const Color borda = Color(0xFFCBD5E1);
  static const Color coracao = Color(0xFFFF5252);
  static const Color fundoImagem = Color(0xFFE2E8F0);
}

/// Estilos de texto reaproveitados nas telas.
class EstilosApp {
  EstilosApp._();

  static const TextStyle tituloBarra = TextStyle(
    fontSize: 20,
    color: Colors.white,
  );

  static const TextStyle titulo = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: CoresApp.azulPetroleo,
    height: 1.2,
  );

  static const TextStyle subtitulo = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: CoresApp.azulPetroleo,
  );

  static const TextStyle descricao = TextStyle(
    fontSize: 14,
    color: CoresApp.textoSecundario,
    height: 1.4,
  );

  static const TextStyle rotulo = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.bold,
    color: CoresApp.azulPetroleo,
  );
}

ThemeData criarTemaCozinhaDeBolso() {
  OutlineInputBorder bordaCampo(Color cor, [double largura = 1]) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: cor, width: largura),
    );
  }

  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: CoresApp.azulPrincipal,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: CoresApp.fundo,
    appBarTheme: const AppBarTheme(
      backgroundColor: CoresApp.azulPetroleo,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      errorMaxLines: 3,
      border: bordaCampo(CoresApp.borda),
      enabledBorder: bordaCampo(CoresApp.borda),
      focusedBorder: bordaCampo(CoresApp.azulPrincipal, 2),
      errorBorder: bordaCampo(Colors.redAccent),
      focusedErrorBorder: bordaCampo(Colors.redAccent, 2),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: CoresApp.azulPetroleo,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(52),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: CoresApp.azulPetroleo,
        side: const BorderSide(color: CoresApp.azulPetroleo),
        minimumSize: const Size.fromHeight(52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: CoresApp.azulPrincipal),
    ),
    navigationBarTheme: const NavigationBarThemeData(
      backgroundColor: Colors.white,
      indicatorColor: CoresApp.azulClaro,
    ),
  );
}