import 'package:material_ui/material_ui.dart';

import '../data/receita_repositorio.dart';
import '../models/receita.dart';
import '../theme/tema_app.dart';
import '../utils/navegacao.dart';
import '../utils/validacao_pesquisa.dart';
import '../widgets/barra_navegacao.dart';
import '../widgets/carregando_lista.dart';
import '../widgets/estado_mensagem.dart';
import '../widgets/receita_card.dart';
import 'detalhes_tela.dart';

enum EstadoPesquisa { inicial, buscando, resultados, semResultados, erro }

/// Tela "Pesquisar receitas".
class PesquisaTela extends StatefulWidget {
  const PesquisaTela({super.key, this.termoInicial});

  /// Termo já validado vindo da tela Explorar (pode ser nulo).
  final String? termoInicial;

  @override
  State<PesquisaTela> createState() => _PesquisaTelaState();
}

class _PesquisaTelaState extends State<PesquisaTela> {
  final ReceitaRepositorio _repositorio = ReceitaRepositorio();
  late final TextEditingController _campoController = TextEditingController(
    text: widget.termoInicial ?? '',
  );
  final FocusNode _campoFoco = FocusNode();

  EstadoPesquisa _estado = EstadoPesquisa.inicial;
  String? _erroCampo;
  String _termoPesquisado = '';
  List<Receita> _resultados = [];

  // Identifica a busca mais recente; respostas antigas são ignoradas.
  int _idBusca = 0;

  @override
  void initState() {
    super.initState();
    final termo = normalizarConsulta(widget.termoInicial ?? '');
    if (termo.isNotEmpty) {
      _estado = EstadoPesquisa.buscando;
      _termoPesquisado = termo;
      _executarBusca(termo);
    }
  }

  @override
  void dispose() {
    _campoController.dispose();
    _campoFoco.dispose();
    super.dispose();
  }

  void _pesquisar() {
    if (_estado == EstadoPesquisa.buscando) return; // evita cliques repetidos

    final erro = validarConsulta(_campoController.text);
    if (erro != null) {
      setState(() => _erroCampo = erro);
      _campoFoco.requestFocus();
      return;
    }

    final termo = normalizarConsulta(_campoController.text);
    _campoController.text = termo; // mostra o termo já ajustado
    FocusScope.of(context).unfocus();
    setState(() {
      _erroCampo = null;
      _termoPesquisado = termo;
      _estado = EstadoPesquisa.buscando;
    });
    _executarBusca(termo);
  }

  Future<void> _executarBusca(String termo) async {
    final id = ++_idBusca;
    try {
      final resultados = await _repositorio.pesquisarPorNome(termo);
      if (!mounted || id != _idBusca) return;
      setState(() {
        _resultados = resultados;
        _estado = resultados.isEmpty
            ? EstadoPesquisa.semResultados
            : EstadoPesquisa.resultados;
      });
    } catch (_) {
      if (!mounted || id != _idBusca) return;
      setState(() => _estado = EstadoPesquisa.erro);
    }
  }

  void _tentarNovamente() {
    setState(() => _estado = EstadoPesquisa.buscando);
    _executarBusca(_termoPesquisado);
  }

  void _limparPesquisa() {
    _idBusca++; // descarta qualquer busca em andamento
    _campoController.clear();
    setState(() {
      _estado = EstadoPesquisa.inicial;
      _resultados = [];
      _erroCampo = null;
    });
    _campoFoco.requestFocus();
  }

  void _alterarPesquisa() {
    _campoFoco.requestFocus();
    _campoController.selection = TextSelection(
      baseOffset: 0,
      extentOffset: _campoController.text.length,
    );
  }

  void _abrirDetalhes(Receita receita) {
    abrirTela(context, DetalhesTela(receita: receita));
  }

  @override
  Widget build(BuildContext context) {
    final buscando = _estado == EstadoPesquisa.buscando;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pesquisar receitas', style: EstilosApp.tituloBarra),
      ),
      bottomNavigationBar: const BarraNavegacao(voltarAoInicio: true),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            if (_estado == EstadoPesquisa.inicial) ...[
              const Text(
                'Qual receita você procura?',
                style: EstilosApp.subtitulo,
              ),
              const SizedBox(height: 20),
            ],
            const Text('Nome da receita', style: EstilosApp.rotulo),
            const SizedBox(height: 8),
            TextField(
              key: const Key('campo-pesquisa'),
              controller: _campoController,
              focusNode: _campoFoco,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => _pesquisar(),
              onChanged: (_) {
                if (_erroCampo != null) setState(() => _erroCampo = null);
              },
              decoration: InputDecoration(
                hintText: 'Buscar pelo nome',
                prefixIcon: const Icon(Icons.search),
                errorText: _erroCampo,
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(
              key: const Key('botao-pesquisar'),
              onPressed: buscando ? null : _pesquisar,
              child: Text(buscando ? 'Pesquisando…' : 'Pesquisar'),
            ),
            ..._conteudoDoEstado(),
          ],
        ),
      ),
    );
  }

  List<Widget> _conteudoDoEstado() {
    switch (_estado) {
      case EstadoPesquisa.inicial:
        return const [
          SizedBox(height: 40),
          Text(
            'Você pode buscar por parte do nome da receita. '
                'As receitas da API estão em inglês, ex.: pizza, chicken, salad.',
            style: EstilosApp.descricao,
          ),
        ];

      case EstadoPesquisa.buscando:
        return [
          const SizedBox(height: 32),
          CarregandoLista(mensagem: 'Pesquisando “$_termoPesquisado”…'),
        ];

      case EstadoPesquisa.resultados:
        return [
          const SizedBox(height: 28),
          Text(
            'Resultados para “$_termoPesquisado”',
            style: EstilosApp.subtitulo.copyWith(fontSize: 18),
          ),
          const SizedBox(height: 4),
          const Text(
            'Toque na receita para ver o preparo.',
            style: EstilosApp.descricao,
          ),
          const SizedBox(height: 16),
          for (final receita in _resultados)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: ReceitaCard(
                receita: receita,
                aoTocar: () => _abrirDetalhes(receita),
              ),
            ),
          const SizedBox(height: 20),
          OutlinedButton(
            onPressed: _limparPesquisa,
            child: const Text('Limpar pesquisa'),
          ),
        ];

      case EstadoPesquisa.semResultados:
        return [
          const SizedBox(height: 40),
          EstadoMensagem(
            icone: const Icon(
              Icons.search,
              size: 40,
              color: CoresApp.azulPetroleo,
            ),
            titulo: 'Nenhum resultado',
            mensagem:
            'Não encontramos receitas para “$_termoPesquisado”. '
                'Tente outro termo, em inglês (ex.: chicken).',
            textoBotao: 'Alterar pesquisa',
            aoPressionarBotao: _alterarPesquisa,
            textoLink: 'Ver todas as receitas',
            aoPressionarLink: () => Navigator.pop(context),
          ),
        ];

      case EstadoPesquisa.erro:
        return [
          const SizedBox(height: 40),
          EstadoMensagem(
            icone: const Text(
              '!',
              style: TextStyle(
                fontSize: 44,
                fontWeight: FontWeight.bold,
                color: CoresApp.azulPetroleo,
              ),
            ),
            titulo: 'Não foi possível pesquisar.',
            mensagem: 'Verifique sua conexão e tente novamente.',
            textoBotao: 'Tentar novamente',
            aoPressionarBotao: _tentarNovamente,
          ),
        ];
    }
  }
}