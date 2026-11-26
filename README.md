# Cozinha de Bolso

App de receitas feito em Flutter para a disciplina de Flutter (atividade "Saborê - Aplicativo de Receitas").

O app pega as receitas da API pública [DummyJSON Recipes](https://dummyjson.com/docs/recipes). Dá pra ver a lista de receitas, pesquisar pelo nome, abrir os detalhes e salvar nos favoritos.

## Funcionalidades

- Tela inicial com campo de pesquisa, algumas sugestões e a lista de receitas
- Lista com imagem, nome, tempo, dificuldade e avaliação de cada receita (se a imagem não carregar, aparece um ícone no lugar)
- Pesquisa pelo nome da receita, feita na própria API (`/recipes/search`)
- Não deixa pesquisar com o campo vazio e tira os espaços a mais
- Tela de detalhes com ingredientes, modo de preparo, porções, tempo total e tipo de refeição
- Favoritos: dá pra favoritar e desfavoritar pelo coração, e eles aparecem na aba Favoritos (ficam salvos só enquanto o app está aberto)
- Mostra cartões de carregamento enquanto busca os dados
- Se der erro (sem internet, tempo esgotado, erro na API ou dados inválidos), aparece uma mensagem e um botão de tentar novamente
- Tem mensagens diferentes para quando não acha nenhuma receita, quando dá erro e quando não tem favoritos
- Quando abre uma receita e volta, a pesquisa continua do jeito que estava

Obs: as receitas da API estão em inglês, então a pesquisa tem que ser em inglês também. Exemplos: `pizza`, `chicken`, `pasta`, `salad`.

## Algumas decisões que tomei

- A tela de detalhes não faz uma nova requisição para a API, porque a lista já traz todos os dados da receita. Então só reaproveitei o objeto que já tinha.
- Enquanto a pesquisa está carregando, o botão de pesquisar fica desativado. Também coloquei um contador (`_idBusca`) para ignorar a resposta de uma pesquisa antiga se o usuário pesquisar de novo.
- Criei uma função `abrirTela` que impede de abrir a mesma tela duas vezes se a pessoa tocar duas vezes rápido.
- Os favoritos ficam num controller só (`FavoritosController`), que todas as telas usam. Uso o `id` da receita como chave, então não tem como repetir.
- Antes de mostrar os dados eu confiro se a API respondeu com status 200 e se o JSON veio certo. No `fromJson` da classe `Receita` eu confiro o tipo de cada campo.

## Organização das pastas

```
lib/
  main.dart
  controllers/   -> favoritos e aba selecionada
  data/          -> acesso à API
  models/        -> classe Receita
  screens/       -> telas do app
  theme/         -> cores e estilos
  utils/         -> validação da pesquisa e navegação
  widgets/       -> componentes reutilizados (card, imagem, botão de favorito...)
test/
  widget_test.dart       -> testes usando uma API falsa
  receitas_exemplo.dart  -> receitas usadas nos testes
```

## Dependências

- `http: ^1.6.0` (para fazer as requisições)
- `material_ui: ^1.11.1` (componentes do Material)
- `cupertino_icons: ^1.0.8` (ícones)
- `flutter_test` e `flutter_lints` (testes e análise do código)

## SDK usado

- Flutter 3.50.1 (canal stable)
- Dart 3.14.0
- Android: Android Gradle Plugin 9.3.1, Gradle 9.5.0 e Kotlin 2.4.20
- Android mínimo: 7.0 (API 24)

## Como rodar o projeto

Precisa ter o Flutter instalado (confira com `flutter doctor`) e internet para o app buscar as receitas.

Clonar o repositório:

```bash
git clone https://github.com/joaofilipe014/Flex-Flutter26JoaoMarcosB4.git
cd Flex-Flutter26JoaoMarcosB4
```

Instalar as dependências:

```bash
flutter pub get
```

Abrir um emulador (ou conectar um celular). Para ver os emuladores disponíveis e abrir um:

```bash
flutter emulators
flutter emulators --launch <id_do_emulador>
```

Rodar o app:

```bash
flutter run
```

Conferir o código e rodar os testes (são 8 testes, todos com uma API falsa, então não precisam de internet):

```bash
flutter analyze
flutter test
```

## Autor

João Filipe Resende Gonçalves Peralta
