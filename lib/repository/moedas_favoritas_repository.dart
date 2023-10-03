import 'package:aplicativo_criptomoeda/adapters/moedas_hive_adapters.dart';
import 'package:aplicativo_criptomoeda/model/moedas_model.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'dart:collection';

class FavoritasRepository extends ChangeNotifier {
  final List<Moeda> _lista = [];
  late LazyBox box;

  FavoritasRepository() {
    _startRepository();
  }
  _startRepository() async {
    await _openBox();
    await _readFavoritas();
  }

  _openBox() async {
    Hive.registerAdapter(MoedasHiveAdapters());
    box = await Hive.openLazyBox<Moeda>('moedas_favoritas');
  }

  _readFavoritas() {
    box.keys.forEach(
      (moeda) async {
        Moeda m = await box.get(moeda);
        _lista.add(m);
        notifyListeners();
      },
    );
  }

  UnmodifiableListView<Moeda> get lista => UnmodifiableListView(_lista);

  saveAll(List<Moeda> moedas) {
    moedas.forEach(
      (moeda) {
        if (!_lista.any((atual) => atual.sigla == moeda.sigla)) {
          _lista.add(moeda);
          box.put(moeda.sigla, moeda);
        }
      },
    );
    notifyListeners();
  }

  remove(Moeda moeda) {
    _lista.remove(moeda);
    box.delete(moeda.sigla);
    notifyListeners();
  }
}
