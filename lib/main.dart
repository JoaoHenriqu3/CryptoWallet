import 'package:aplicativo_criptomoeda/configs/app_settings.dart';
import 'package:aplicativo_criptomoeda/configs/hive_configs.dart';
import 'package:aplicativo_criptomoeda/my_app.dart';
import 'package:aplicativo_criptomoeda/repository/moedas_favoritas_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveConfigs.start();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppSettings()),
        ChangeNotifierProvider(create: (context) => FavoritasRepository()),
      ],
      child: const MyApp(),
    ),
  );
}
