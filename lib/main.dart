import 'package:material_ui/material_ui.dart';   // ← main.dart
import 'screens/tela_principal.dart';
import 'theme/tema_app.dart';

void main() {
  runApp(const CozinhaDeBolsoApp());
}

class CozinhaDeBolsoApp extends StatelessWidget {
  const CozinhaDeBolsoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cozinha de Bolso',
      debugShowCheckedModeBanner: false,
      theme: criarTemaCozinhaDeBolso(),
      home: const TelaPrincipal(),
    );
  }
}