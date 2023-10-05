import 'package:aplicativo_criptomoeda/repository/conta_repository.dart';
import 'package:aplicativo_criptomoeda/repository/moedas_favoritas_repository.dart';
import 'package:aplicativo_criptomoeda/config/app_settings.dart';
import 'package:aplicativo_criptomoeda/config/hive_configs.dart';
import 'package:aplicativo_criptomoeda/my_app.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveConfigs.start();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ContaRepository()),
        ChangeNotifierProvider(create: (context) => AppSettings()),
        ChangeNotifierProvider(create: (context) => FavoritasRepository()),
      ],
      child: const MyApp(),
    ),
  );
}
