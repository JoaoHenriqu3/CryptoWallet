import 'package:aplicativo_criptomoeda/page/login_page.dart';
import 'package:aplicativo_criptomoeda/page/home_page.dart';
import 'package:aplicativo_criptomoeda/service/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class AuthCheck extends StatefulWidget {
  const AuthCheck({super.key});

  @override
  State<AuthCheck> createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  @override
  Widget build(BuildContext context) {
    AuthService auth = Provider.of<AuthService>(context);

    if (auth.isLoading) {
      return loading();
    } else if (auth.usuario == null) {
      return const LoginPage();
    } else {
      return const HomePage();
    }
  }

  loading() {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
