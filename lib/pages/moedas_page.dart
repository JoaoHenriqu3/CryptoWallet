import 'package:aplicativo_criptomoeda/model/moedas_model.dart';
import 'package:aplicativo_criptomoeda/repository/moedas_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MoedasPage extends StatefulWidget {
  const MoedasPage({Key? key}) : super(key: key);

  @override
  State<MoedasPage> createState() => _MoedasPageState();
}

class _MoedasPageState extends State<MoedasPage> {
  final listaMoedas = MoedasRepository.listaMoedas;
  NumberFormat real = NumberFormat.currency(locale: 'pt_BR', name: 'R\$');
  List<MoedasModel> moedasSelecionadas = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Criptomoedas'),
      ),
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
              title: Text(
                listaMoedas[moeda].nome,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                ),
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
            );
          },
          padding: const EdgeInsets.all(16),
          separatorBuilder: (_, __) => const Divider(),
          itemCount: listaMoedas.length),
    );
  }
}
