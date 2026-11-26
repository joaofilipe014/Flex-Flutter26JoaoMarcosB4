import 'package:material_ui/material_ui.dart';

import '../theme/tema_app.dart';

/// Bloco reutilizado nos estados de erro, "nenhum resultado" e "nenhum favorito".
class EstadoMensagem extends StatelessWidget {
  const EstadoMensagem({
    super.key,
    required this.icone,
    required this.titulo,
    required this.mensagem,
    this.textoBotao,
    this.aoPressionarBotao,
    this.textoLink,
    this.aoPressionarLink,
  });

  final Widget icone;
  final String titulo;
  final String mensagem;
  final String? textoBotao;
  final VoidCallback? aoPressionarBotao;
  final String? textoLink;
  final VoidCallback? aoPressionarLink;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: Container(
            width: 108,
            height: 108,
            decoration: const BoxDecoration(
              color: CoresApp.azulClaro,
              shape: BoxShape.circle,
            ),
            child: Center(child: icone),
          ),
        ),
        const SizedBox(height: 32),
        Text(titulo, style: EstilosApp.titulo),
        const SizedBox(height: 16),
        Text(mensagem, style: EstilosApp.descricao.copyWith(fontSize: 15)),
        const SizedBox(height: 40),
        if (textoBotao != null)
          FilledButton(onPressed: aoPressionarBotao, child: Text(textoBotao!)),
        if (textoLink != null) ...[
          const SizedBox(height: 8),
          TextButton(onPressed: aoPressionarLink, child: Text(textoLink!)),
        ],
      ],
    );
  }
}