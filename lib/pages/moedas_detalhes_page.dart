import 'package:aplicativo_criptomoeda/model/moedas_model.dart';
import 'package:flutter/material.dart';

class MoedasDetalhesPage extends StatefulWidget {
  Moeda moeda;

  MoedasDetalhesPage({Key? key, required this.moeda}) : super(key: key);

  @override
  State<MoedasDetalhesPage> createState() => _MoedasDetalhesPageState();
}

class _MoedasDetalhesPageState extends State<MoedasDetalhesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.moeda.nome),
      ),
      body: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 50,
                child: Image.asset(widget.moeda.icone),
              ),
            ],
          )
        ],
      ),
    );
  }
}
