import 'package:flutter/material.dart';

class PaginaInicial extends StatefulWidget {
  const PaginaInicial({super.key});

  @override
  State<PaginaInicial> createState() => _PaginaInicialState();
}

class _PaginaInicialState extends State<PaginaInicial> {
  final TextEditingController _campoPesquisaController =
  TextEditingController();
  final FocusNode _campoPesquisaFocus = FocusNode();

  String? _mensagemErro;
  String? _termoPesquisado;

  // A pesquisa ainda não consulta um banco de dados.
  void _pesquisarReceita() {
    final consulta = _campoPesquisaController.text
        .trim()
        .replaceAll(RegExp(r'\s+'), ' ');

    if (consulta.isEmpty) {
      setState(() {
        _mensagemErro =
        'Digite o nome de uma receita antes de pesquisar. Ex.: bolo de cenoura.';
        _termoPesquisado = null;
      });
      _campoPesquisaFocus.requestFocus();
      return;
    }

    setState(() {
      _mensagemErro = null;
      _termoPesquisado = consulta;
    });
  }

  void _preencherSugestao(String sugestao) {
    setState(() {
      _campoPesquisaController.text = sugestao;
      _campoPesquisaController.selection = TextSelection.collapsed(
        offset: sugestao.length,
      );
      _mensagemErro = null;
      _termoPesquisado = null;
    });
    _campoPesquisaFocus.requestFocus();
  }

  @override
  void dispose() {
    _campoPesquisaController.dispose();
    _campoPesquisaFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.restaurant_menu, size: 25),
            SizedBox(width: 10),
            Text('Cozinha de Bolso'),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildApresentacao(),
              const SizedBox(height: 28),
              Text(
                'Pesquisar receitas',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: const Color(0xFF164E63),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Digite o nome da receita que você deseja encontrar.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF475569),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                key: const Key('campo-pesquisa'),
                controller: _campoPesquisaController,
                focusNode: _campoPesquisaFocus,
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.search,
                onSubmitted: (_) => _pesquisarReceita(),
                onChanged: (_) {
                  if (_mensagemErro != null || _termoPesquisado != null) {
                    setState(() {
                      _mensagemErro = null;
                      _termoPesquisado = null;
                    });
                  }
                },
                decoration: InputDecoration(
                  labelText: 'Nome da receita',
                  hintText: 'Ex.: panqueca de banana',
                  prefixIcon: const Icon(Icons.search),
                  errorText: _mensagemErro,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _pesquisarReceita,
                  icon: const Icon(Icons.search),
                  label: const Text('Pesquisar receita'),
                ),
              ),
              if (_termoPesquisado != null) ...[
                const SizedBox(height: 20),
                _buildResultadoPesquisa(_termoPesquisado!),
              ],
              const SizedBox(height: 30),
              Text(
                'Ideias para começar',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: const Color(0xFF164E63),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Toque em uma sugestão para preencher a pesquisa.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: const Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildSugestao('Bolo de cenoura'),
                  _buildSugestao('Panqueca de banana'),
                  _buildSugestao('Macarrão alho e óleo'),
                ],
              ),
              const SizedBox(height: 28),
              _buildRodapeInformativo(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildApresentacao() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF164E63),
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.soup_kitchen_outlined,
            color: Color(0xFFA5D8E8),
            size: 38,
          ),
          SizedBox(height: 16),
          Text(
            'Sua próxima receita começa aqui!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              height: 1.2,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Encontre inspirações para preparar algo gostoso, '
                'simples e do seu jeito.',
            style: TextStyle(
              color: Color(0xFFE0F2F7),
              fontSize: 15,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultadoPesquisa(String termo) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFE0F2F7),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF0E7490)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.check_circle_outline, color: Color(0xFF164E63)),
              SizedBox(width: 8),
              Text(
                'Pesquisa recebida',
                style: TextStyle(
                  color: Color(0xFF164E63),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text('Você pesquisou por:'),
          const SizedBox(height: 4),
          Text(
            termo,
            style: const TextStyle(
              color: Color(0xFF164E63),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'A busca foi registrada. Os resultados de receitas '
                'serão adicionados em uma próxima etapa.',
            style: TextStyle(color: Color(0xFF334155), height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _buildSugestao(String texto) {
    return ActionChip(
      label: Text(texto),
      avatar: const Icon(Icons.restaurant, size: 17),
      onPressed: () => _preencherSugestao(texto),
      backgroundColor: Colors.white,
      side: const BorderSide(color: Color(0xFFCBD5E1)),
      labelStyle: const TextStyle(color: Color(0xFF164E63)),
    );
  }

  Widget _buildRodapeInformativo() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.lightbulb_outline, color: Color(0xFF0E7490)),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Dica: você pode pesquisar receitas com mais de uma palavra, '
                  'como “bolo de chocolate”. Espaços extras no início, no fim '
                  'ou entre as palavras são ajustados automaticamente.',
              style: TextStyle(color: Color(0xFF475569), height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}