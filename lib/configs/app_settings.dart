import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettings extends ChangeNotifier {
  //Criando uma instancia para acessar o sistema interno de arquivos
  late SharedPreferences _prefs;

  //Salvar o meu LOCALE (Localizacao do meu aplicativo)
  Map<String, String> locale = {
    'locale': 'pt_BR',
    'name': 'R\$',
  };

  //Construtor chamando o start
  //Construtor nao pode ser assincrono
  //Entao eu chamo o meu metodo e o meu metodo que vai ser assincrono
  AppSettings() {
    _startSettings();
  }

//inicializacao do SharedPreference
//Ler se ja esta salvo... as informacoes do locale
  _startSettings() async {
    await _startPreferences();
    await _readLocale();
  }

  Future<void> _startPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }

  _readLocale() {
    final local = _prefs.getString('local') ?? 'pt_BR';
    final name = _prefs.getString('name') ?? 'R\$';
    locale = {
      'locale': local,
      'name': name,
    };
    notifyListeners();
  }

//Metodo publico para que qualquer classe possa alterar o locale
//Onde o usuario estiver e tiver essa funcionalidade, ele pode alterar o locale.
  setLocale(String local, String name) async {
    await _prefs.setString('local', local);
    await _prefs.setString('name', name);
    await _readLocale();
  }
}
