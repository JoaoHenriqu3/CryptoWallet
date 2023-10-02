import 'package:aplicativo_criptomoeda/model/moedas_model.dart';
import 'package:aplicativo_criptomoeda/pages/moedas_detalhes_page.dart';
import 'package:aplicativo_criptomoeda/repository/favoritas_repository.dart';
import 'package:aplicativo_criptomoeda/repository/moedas_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MoedasPage extends StatefulWidget {
  const MoedasPage({Key? key}) : super(key: key);

  @override
  State<MoedasPage> createState() => _MoedasPageState();
}

class _MoedasPageState extends State<MoedasPage> {
  final listaMoedas = MoedasRepository.listaMoedas;
  NumberFormat real = NumberFormat.currency(locale: 'pt_BR', name: 'R\$');
  List<Moeda> moedasSelecionadas = [];
  late FavoritasRepository moedasFavoritas;

  appBarDinamica() {
    if (moedasSelecionadas.isEmpty) {
      return AppBar(
        title: const Text('Criptomoedas'),
      );
    } else {
      return AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            setState(() {
              moedasSelecionadas = [];
            });
          },
        ),
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

  @override
  Widget build(BuildContext context) {
    // moedasFavoritas = Provider.of<FavoritasRepository>(context);
    moedasFavoritas = context.watch<FavoritasRepository>();

    return Scaffold(
        appBar: appBarDinamica(),
        body: ListView.separated(
          itemBuilder: (BuildContext context, int moeda) {
            return ListTile(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              leading: (moedasSelecionadas.contains(listaMoedas[moeda]))
                  ? const CircleAvatar(child: Icon(Icons.check))
                  : SizedBox(
                      width: 40,
                      child: Image.asset(listaMoedas[moeda].icone),
                    ),
              title: Row(
                children: [
                  Text(
                    listaMoedas[moeda].nome,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (moedasFavoritas.lista.contains(listaMoedas[moeda]))
                    const Icon(
                      Icons.circle,
                      color: Colors.amber,
                      size: 8,
                    )
                ],
              ),
              trailing: Text(
                real.format(listaMoedas[moeda].preco),
              ),
              selected: moedasSelecionadas.contains(listaMoedas[moeda]),
              selectedColor: Colors.indigo[50],
              onLongPress: () {
                setState(() {
                  (moedasSelecionadas.contains(listaMoedas[moeda]))
                      ? moedasSelecionadas.remove(listaMoedas[moeda])
                      : moedasSelecionadas.add(listaMoedas[moeda]);
                });
              },
              onTap: () => mostrarDetalhes(listaMoedas[moeda]),
            );
          },
          padding: const EdgeInsets.all(16),
          separatorBuilder: (_, __) => const Divider(),
          itemCount: listaMoedas.length,
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
}
