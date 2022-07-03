import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:leilabeleiza/pages/cadastro.dart';
import 'package:leilabeleiza/pages/extract_client.dart';
import 'package:leilabeleiza/pages/home.dart';
import 'package:leilabeleiza/pages/login.dart';
import 'package:leilabeleiza/themes/main_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'data/connect.dart';
import 'models/cliente.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);

  const supabaseUrl = "https://hdluhckhlzyipafrjczm.supabase.co";
  const supabaseKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhkbHVoY2tobHp5aXBhZnJqY3ptIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NTY3OTIxMzMsImV4cCI6MTk3MjM2ODEzM30.QzwpI0XzdkgzIRFQb3uDXPvQ38-c5-BJ4LPiaw_t5Qs';

  GetIt getIt = GetIt.instance;
  getIt.registerSingleton<SupabaseClient>(
      SupabaseClient(supabaseUrl, supabaseKey));

  final prefs = await SharedPreferences.getInstance();
  final bool? isLoggedIn = prefs.getBool('isLoggedIn');

  if (isLoggedIn != null) {
    String? email = prefs.getString('email');
    String? senha = prefs.getString('senha');
    final response = await connect(email!, senha!);

    if (response != null) {
      runApp(
        MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: mainTheme,
          initialRoute: '/home',
          routes: {
            '/': (context) => const Login(),
            '/extractCliente': (context) => const ExtractClient(),
            '/cadastro': (context) => const Cadastro(),
            '/home': (context) => Home(cliente: response)
          },
        ),
      );
    }
  }
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: mainTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const Login(),
        '/extractCliente': (context) => const ExtractClient(),
        '/cadastro': (context) => const Cadastro(),
        '/home': (context) => Home(cliente: Cliente(null, null, null))
      },
    ),
  );
}