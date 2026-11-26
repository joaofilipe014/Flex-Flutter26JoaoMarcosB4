import 'package:material_ui/material_ui.dart';
import '../theme/tema_app.dart';

/// Caixinha azul dos detalhes, ex.: "35 min / tempo total".
class InfoResumo extends StatelessWidget {
  const InfoResumo({super.key, required this.valor, required this.rotulo});

  final String valor;
  final String rotulo;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: CoresApp.azulClaro,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            valor,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: CoresApp.azulPetroleo,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            rotulo,
            style: const TextStyle(
              fontSize: 11,
              color: CoresApp.textoSecundario,
            ),
          ),
        ],
      ),
    );
  }
}