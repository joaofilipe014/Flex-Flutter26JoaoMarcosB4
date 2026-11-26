import 'package:material_ui/material_ui.dart';

import '../data/receita_repositorio.dart';
import '../models/receita.dart';
import '../theme/tema_app.dart';
import '../utils/navegacao.dart';
import '../utils/validacao_pesquisa.dart';
import '../widgets/carregando_lista.dart';
import '../widgets/estado_mensagem.dart';
import '../widgets/receita_card.dart';
import 'detalhes_tela.dart';
import 'pesquisa_tela.dart';

/// Aba "Explorar": página inicial do Cozinha de Bolso.
class ExplorarTela extends StatefulWidget {
  const ExplorarTela({super.key});

  @override
  State<ExplorarTela> createState() => _ExplorarTelaState();
}

class _ExplorarTelaState extends State<ExplorarTela> {
  final ReceitaRepositorio _repositorio = ReceitaRepositorio();
  final TextEditingController _campoPesquisaController =
  TextEditingController();
  final FocusNode _campoPesquisaFocus = FocusNode();

  List<Receita> _receitas = [];
  bool _carregando = true;
  String? _erroCarregamento;
  String? _mensagemErro;

  @override
  void initState() {
    super.initState();
    // Carrega só uma vez, na primeira abertura (e não a cada build).
    _carregarReceitas();
  }

  @override
  void dispose() {
    _campoPesquisaController.dispose();
    _campoPesquisaFocus.dispose();
    super.dispose();
  }

  Future<void> _carregarReceitas() async {
    try {
      final receitas = await _repositorio.buscarTodas();
      if (!mounted) return;
      setState(() {
        _receitas = receitas;
        _carregando = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _erroCarregamento = 'Verifique sua conexão e tente novamente.';
        _carregando = false;
      });
    }
  }

  void _tentarNovamente() {
    setState(() {
      _carregando = true;
      _erroCarregamento = null;
    });
    _carregarReceitas();
  }

  void _pesquisarReceita() {
    final erro = validarConsulta(_campoPesquisaController.text);
    if (erro != null) {
      // Consulta vazia ou só com espaços: não inicia a pesquisa.
      setState(() => _mensagemErro = erro);
      _campoPesquisaFocus.requestFocus();
      return;
    }

    setState(() => _mensagemErro = null);
    final termo = normalizarConsulta(_campoPesquisaController.text);
    abrirTela(context, PesquisaTela(termoInicial: termo));
  }

  void _preencherSugestao(String sugestao) {
    setState(() {
      _campoPesquisaController.text = sugestao;
      _campoPesquisaController.selection = TextSelection.collapsed(
        offset: sugestao.length,
      );
      _mensagemErro = null;
    });
    _campoPesquisaFocus.requestFocus();
  }

  void _abrirDetalhes(Receita receita) {
    abrirTela(context, DetalhesTela(receita: receita));
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
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
          children: [
            _buildApresentacao(),
            const SizedBox(height: 28),
            const Text('Pesquisar receitas', style: EstilosApp.titulo),
            const SizedBox(height: 8),
            const Text(
              'Digite o nome da receita que você deseja encontrar.',
              style: EstilosApp.descricao,
            ),
            const SizedBox(height: 16),
            TextField(
              key: const Key('campo-busca-inicio'),
              controller: _campoPesquisaController,
              focusNode: _campoPesquisaFocus,
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => _pesquisarReceita(),
              onChanged: (_) {
                if (_mensagemErro != null) {
                  setState(() => _mensagemErro = null);
                }
              },
              decoration: InputDecoration(
                labelText: 'Nome da receita',
                hintText: 'Ex.: pizza, chicken, salad',
                prefixIcon: const Icon(Icons.search),
                errorText: _mensagemErro,
              ),
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              key: const Key('botao-busca-inicio'),
              onPressed: _pesquisarReceita,
              icon: const Icon(Icons.search),
              label: const Text('Pesquisar receita'),
            ),
            const SizedBox(height: 30),
            const Text('Ideias para começar', style: EstilosApp.subtitulo),
            const SizedBox(height: 8),
            Text(
              'Toque em uma sugestão para preencher a pesquisa.',
              style: EstilosApp.descricao.copyWith(fontSize: 12),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildSugestao('Pizza'),
                _buildSugestao('Pasta'),
                _buildSugestao('Cookies'),
              ],
            ),
            const SizedBox(height: 30),
            const Text('Receitas disponíveis', style: EstilosApp.subtitulo),
            const SizedBox(height: 4),
            const Text(
              'Toque em uma receita para ver o preparo.',
              style: EstilosApp.descricao,
            ),
            const SizedBox(height: 16),
            ..._buildListaReceitas(),
            const SizedBox(height: 16),
            _buildRodapeInformativo(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildListaReceitas() {
    if (_carregando) {
      return const [CarregandoLista()];
    }

    if (_erroCarregamento != null) {
      return [
        EstadoMensagem(
          icone: const Text(
            '!',
            style: TextStyle(
              fontSize: 44,
              fontWeight: FontWeight.bold,
              color: CoresApp.azulPetroleo,
            ),
          ),
          titulo: 'Não foi possível carregar as receitas.',
          mensagem: _erroCarregamento!,
          textoBotao: 'Tentar novamente',
          aoPressionarBotao: _tentarNovamente,
        ),
      ];
    }

    return [
      for (final receita in _receitas)
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: ReceitaCard(
            receita: receita,
            aoTocar: () => _abrirDetalhes(receita),
          ),
        ),
    ];
  }

  Widget _buildApresentacao() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: CoresApp.azulPetroleo,
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.soup_kitchen_outlined,
            color: CoresApp.azulDestaque,
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
              color: CoresApp.azulClaro,
              fontSize: 15,
              height: 1.45,
            ),
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
      side: const BorderSide(color: CoresApp.borda),
      labelStyle: const TextStyle(color: CoresApp.azulPetroleo),
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
          Icon(Icons.lightbulb_outline, color: CoresApp.azulPrincipal),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Dica: você pode pesquisar receitas com mais de uma palavra, '
                  'como “bolo de chocolate”. Espaços extras no início, no fim '
                  'ou entre as palavras são ajustados automaticamente.',
              style: TextStyle(color: CoresApp.textoSecundario, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}