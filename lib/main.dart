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
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'data/connect.dart';
import 'models/cliente.dart';

Future<void> main() async {
  await dotenv.load();

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ],
  );

  GetIt getIt = GetIt.instance;
  getIt.registerSingleton<SupabaseClient>(
    SupabaseClient(
      dotenv.env['SUPABASE_URL']!,
      dotenv.env['SUPABASE_KEY']!,
    ),
  );

  final prefs = await SharedPreferences.getInstance();
  final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  if (isLoggedIn) {
    String email = prefs.getString('email') ?? '';
    String senha = prefs.getString('senha') ?? '';
    final response = await connect(email, senha);

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
