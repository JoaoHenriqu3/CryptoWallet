import 'package:aplicativo_criptomoeda/repository/conta_repository.dart';
import 'package:aplicativo_criptomoeda/model/posicao_model.dart';
import 'package:aplicativo_criptomoeda/config/app_settings.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CarteiraPage extends StatefulWidget {
  const CarteiraPage({super.key});

  @override
  State<CarteiraPage> createState() => _CarteiraPageState();
}

class _CarteiraPageState extends State<CarteiraPage> {
  int index = 0;
  late NumberFormat real;
  List<Posicao> carteira = [];
  double totalCarteira = 0;
  late ContaRepository conta;
  double saldo = 0;
  String graficoLabel = '';
  double graficoValor = 0;

  @override
  Widget build(BuildContext context) {
    conta = context.watch<ContaRepository>();
    final loc = context.read<AppSettings>().locale;
    real = NumberFormat.currency(locale: loc['locale'], name: loc['name']);
    saldo = conta.saldo;

    setTotalCarteira();

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 48),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Padding(
            padding: EdgeInsets.only(top: 48, bottom: 8),
            child: Text(
              'Valor da Carteira',
              style: TextStyle(fontSize: 18),
            ),
          ),
          Text(
            real.format(totalCarteira),
            style: const TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.w700,
              letterSpacing: -1.5,
            ),
          ),
          loadGrafico(),
          loadHistorico(),
        ]),
      ),
    );
  }

  setTotalCarteira() {
    final carteiraList = conta.carteira;
    setState(() {
      totalCarteira = conta.saldo;
      for (var posicao in carteiraList) {
        totalCarteira += posicao.moeda.preco * posicao.quantidade;
      }
    });
  }

  setGraficoDados(int index) {
    if (index < 0) return;
    if (index == carteira.length) {
      graficoLabel = 'Saldo';
      graficoValor = conta.saldo;
    } else {
      graficoLabel = carteira[index].moeda.nome;
      graficoValor = carteira[index].moeda.preco * carteira[index].quantidade;
    }
  }

  loadCarteira() {
    setGraficoDados(index);
    carteira = conta.carteira;
    final tamanhoLista = carteira.length + 1;

    return List.generate(
      tamanhoLista,
      (i) {
        final isTouched = i == index;
        final isSaldo = i == tamanhoLista - 1;
        final fontSize = isTouched ? 18.0 : 14.0;
        final radius = isTouched ? 60.0 : 50.0;
        final color = isTouched ? Colors.tealAccent : Colors.tealAccent[400];

        double porcentagem = 0;
        if (!isSaldo) {
          porcentagem =
              carteira[i].moeda.preco * carteira[i].quantidade / totalCarteira;
        } else {
          porcentagem = (conta.saldo > 0) ? conta.saldo / totalCarteira : 0;
        }
        porcentagem *= 100;

        return PieChartSectionData(
          color: color,
          value: porcentagem,
          title: '${porcentagem.toStringAsFixed(0)}%',
          radius: radius,
          titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.black87),
        );
      },
    );
  }

  loadGrafico() {
    return (conta.saldo < 0)
        ? Container(
            width: MediaQuery.of(context).size.width,
            height: 200,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Stack(
            alignment: Alignment.center,
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 5,
                    centerSpaceRadius: 120,
                    sections: loadCarteira(),
                    pieTouchData: PieTouchData(
                      touchCallback: (touch) => setState(
                        () {
                          index = touch.touchedSection!.touchedSectionIndex;
                          setGraficoDados(index);
                        },
                      ),
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  Text(
                    graficoLabel,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.teal,
                    ),
                  ),
                  Text(
                    real.format(graficoValor),
                    style: const TextStyle(
                      fontSize: 28,
                    ),
                  )
                ],
              ),
            ],
          );
  }

  loadHistorico() {
    final historico = conta.historico;
    final date = DateFormat('dd/MM/yyyy - hh:mm');

    List<Widget> widgets = [];

    for (var operacao in historico) {
      widgets.add(ListTile(
        title: Text(operacao.moeda.nome),
        subtitle: Text(date.format(operacao.dataOperacao)),
        trailing: Text(
            (operacao.moeda.preco * operacao.quantidade).toStringAsFixed(2)),
      ));
      widgets.add(const Divider());
    }

    return Column(
      children: widgets,
    );
  }
}
