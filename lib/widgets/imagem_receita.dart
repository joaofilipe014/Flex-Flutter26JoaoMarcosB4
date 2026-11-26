import 'package:material_ui/material_ui.dart';

import '../theme/tema_app.dart';

/// Mostra a imagem da receita ou um ícone no lugar quando ela falta ou falha.
class ImagemReceita extends StatelessWidget {
  const ImagemReceita({
    super.key,
    required this.url,
    this.largura,
    this.altura,
    this.raio = 12,
    this.tamanhoIcone = 32,
  });

  final String? url;
  final double? largura;
  final double? altura;
  final double raio;
  final double tamanhoIcone;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(raio),
      child: Container(
        width: largura,
        height: altura,
        color: CoresApp.fundoImagem,
        child: url == null
            ? _alternativa()
            : Image.network(
          url!,
          fit: BoxFit.cover,
          errorBuilder: (context, erro, pilha) => _alternativa(),
        ),
      ),
    );
  }

  Widget _alternativa() {
    return Center(
      child: Icon(
        Icons.restaurant,
        size: tamanhoIcone,
        color: CoresApp.textoSecundario,
        semanticLabel: 'Imagem indisponível',
      ),
    );
  }
}