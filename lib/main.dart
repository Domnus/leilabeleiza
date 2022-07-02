import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:leilabeleiza/pages/cadastro.dart';
import 'package:leilabeleiza/pages/home.dart';
import 'package:leilabeleiza/pages/login.dart';
import 'package:leilabeleiza/themes/main_theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);

  const supabaseUrl = "https://hdluhckhlzyipafrjczm.supabase.co";
  const supabaseKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhkbHVoY2tobHp5aXBhZnJqY3ptIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NTY3OTIxMzMsImV4cCI6MTk3MjM2ODEzM30.QzwpI0XzdkgzIRFQb3uDXPvQ38-c5-BJ4LPiaw_t5Qs';

  GetIt getIt = GetIt.instance;

  getIt.registerSingleton<SupabaseClient>(SupabaseClient(supabaseUrl, supabaseKey));

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: mainTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const Login(),
        '/cadastro': (context) => const Cadastro(),
        '/home': (context) => const Home()
      },
    ),
  );
}
