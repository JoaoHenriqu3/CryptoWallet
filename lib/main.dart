import 'package:aplicativo_criptomoeda/my_app.dart';
import 'package:aplicativo_criptomoeda/repository/favoritas_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
        create: (context) => FavoritasRepository(), child: const MyApp()),
  );
}
