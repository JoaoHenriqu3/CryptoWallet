import 'package:aplicativo_criptomoeda/repository/moedas_favoritas_repository.dart';
import 'package:aplicativo_criptomoeda/repository/moedas_repository.dart';
import 'package:aplicativo_criptomoeda/repository/conta_repository.dart';
import 'package:aplicativo_criptomoeda/service/auth_service.dart';
import 'package:aplicativo_criptomoeda/config/app_settings.dart';
import 'package:aplicativo_criptomoeda/config/hive_configs.dart';
import 'package:aplicativo_criptomoeda/my_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveConfigs.start();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthService()),
        ChangeNotifierProvider(create: (context) => MoedaRepository()),
        ChangeNotifierProvider(
            create: (context) =>
                ContaRepository(moedas: context.read<MoedaRepository>())),
        ChangeNotifierProvider(create: (context) => AppSettings()),
        ChangeNotifierProvider(
            create: (context) => FavoritasRepository(
                auth: context.read<AuthService>(),
                moedas: context.read<MoedaRepository>()))
      ],
      child: const MyApp(),
    ),
  );
}
