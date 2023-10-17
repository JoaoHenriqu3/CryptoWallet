import 'package:aplicativo_criptomoeda/page/comprar_page.dart';
import 'package:aplicativo_criptomoeda/widget/auth_check.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CRYPTO WALLET',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.indigo),
      home: const AuthCheck(),
    );
  }
}
