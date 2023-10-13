import 'package:aplicativo_criptomoeda/repository/moedas_favoritas_repository.dart';
import 'package:aplicativo_criptomoeda/repository/moedas_repository.dart';
import 'package:aplicativo_criptomoeda/page/moedas_detalhes_page.dart';
import 'package:aplicativo_criptomoeda/config/app_settings.dart';
import 'package:aplicativo_criptomoeda/model/moedas_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MoedasPage extends StatefulWidget {
  const MoedasPage({Key? key}) : super(key: key);

  @override
  State<MoedasPage> createState() => _MoedasPageState();
}

class _MoedasPageState extends State<MoedasPage> {
  late List<Moeda> tabela;
  late NumberFormat real;
  late Map<String, String> loc;
  List<Moeda> moedasSelecionadas = [];
  late FavoritasRepository moedasFavoritas;
  late MoedaRepository moedas;
  TextEditingController buscarMoedaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // moedasFavoritas = Provider.of<FavoritasRepository>(context);
    moedasFavoritas = context.watch<FavoritasRepository>();
    moedas = context.watch<MoedaRepository>();
    tabela = moedas.tabela;
    //Fazer a leitura do Read para carregar o locale
    readNumberFormat();
    return Scaffold(
        appBar: appBarDinamica(),
        body: RefreshIndicator(
          onRefresh: () => moedas.checkPrecos(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  width: double.infinity,
                  height: 50.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.0),
                    border: Border.all(
                        color: Colors.black.withOpacity(0.5), width: 1.0),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 8.0),
                      Icon(Icons.search, color: Colors.black.withOpacity(0.5)),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: TextField(
                          controller: buscarMoedaController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Search",
                            hintStyle: TextStyle(
                              color: Colors.black.withOpacity(0.5),
                            ),
                          ),
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                      const SizedBox(
                        width: 8.0,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ListView.separated(
                  itemBuilder: (BuildContext context, int moeda) {
                    return ListTile(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                      leading: (moedasSelecionadas.contains(tabela[moeda]))
                          ? const CircleAvatar(child: Icon(Icons.check))
                          : SizedBox(
                              width: 40,
                              child: Image.network(tabela[moeda].icone),
                            ),
                      title: Row(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tabela[moeda].nome,
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                tabela[moeda].sigla,
                                style: const TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          if (moedasFavoritas.lista
                              .any((fav) => fav.sigla == tabela[moeda].sigla))
                            const Icon(
                              Icons.star_rounded,
                              color: Colors.amber,
                              size: 18,
                            )
                        ],
                      ),
                      trailing: Text(
                        real.format(tabela[moeda].preco),
                      ),
                      selected: moedasSelecionadas.contains(tabela[moeda]),
                      selectedColor: Colors.indigo[50],
                      onLongPress: () {
                        setState(() {
                          (moedasSelecionadas.contains(tabela[moeda]))
                              ? moedasSelecionadas.remove(tabela[moeda])
                              : moedasSelecionadas.add(tabela[moeda]);
                        });
                      },
                      onTap: () => mostrarDetalhes(tabela[moeda]),
                    );
                  },
                  padding: const EdgeInsets.all(16),
                  separatorBuilder: (_, __) => const Divider(),
                  itemCount: tabela.length,
                ),
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: moedasSelecionadas.isNotEmpty
            ? FloatingActionButton.extended(
                onPressed: () {
                  moedasFavoritas.saveAll(moedasSelecionadas);
                  limparSelecionadas();
                },
                icon: const Icon(Icons.star),
                label: const Text(
                  'FAVORITAR',
                  style: TextStyle(
                    letterSpacing: 0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : null);
  }

//Esta lendo o provider
//Esta formatando o numero de acordo com a preferencia do usuario
  readNumberFormat() {
    loc = context.watch<AppSettings>().locale;
    real = NumberFormat.currency(locale: loc['locale'], name: loc['name']);
  }

  changeLanguageButton() {
    final locale = loc['locale'] == 'pt_BR' ? 'en_US' : 'pt_BR';
    final name = loc['locale'] == 'pt_BR' ? '\$' : 'R\$';

    return PopupMenuButton(
      icon: const Icon(Icons.language),
      itemBuilder: (context) => [
        PopupMenuItem(
            child: ListTile(
          leading: const Icon(Icons.swap_vert),
          title: Text('Usar $locale'),
          onTap: () {
            context.read<AppSettings>().setLocale(locale, name);
            Navigator.pop(context);
          },
        )),
      ],
    );
  }

  appBarDinamica() {
    if (moedasSelecionadas.isEmpty) {
      return AppBar(
        centerTitle: true,
        title: const Text('Crypto Wallet'),
        leading: const Icon(Icons.menu),
        actions: [changeLanguageButton()],
      );
    } else {
      return AppBar(
        leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              setState(() {
                moedasSelecionadas = [];
              });
            }),
        title: Text('${moedasSelecionadas.length} selecionadas'),
        backgroundColor: Colors.blueGrey[50],
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black87),
        titleTextStyle: const TextStyle(
          color: Colors.black87,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      );
    }
  }

  mostrarDetalhes(Moeda moeda) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => MoedasDetalhesPage(moeda: moeda),
        ));
  }

  limparSelecionadas() {
    setState(() {
      moedasSelecionadas = [];
    });
  }
}
