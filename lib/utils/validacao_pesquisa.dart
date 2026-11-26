const String mensagemConsultaVazia =
    'Digite o nome de uma receita antes de pesquisar. Ex.: bolo de cenoura.';

/// Remove espaços do início e do fim e junta espaços repetidos no meio.
/// "  bolo   de  chocolate " -> "bolo de chocolate"
String normalizarConsulta(String texto) {
  return texto.trim().replaceAll(RegExp(r'\s+'), ' ');
}

/// Retorna a mensagem de erro, ou null quando a consulta é válida.
String? validarConsulta(String texto) {
  if (normalizarConsulta(texto).isEmpty) return mensagemConsultaVazia;
  return null;
}