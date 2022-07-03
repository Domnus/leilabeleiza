import 'package:flutter/Material.dart';
import 'package:shared_preferences/shared_preferences.dart';

logout(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();

  prefs.setBool('isLoggedIn', false);
  prefs.remove('usuario');
  prefs.remove('senha');

  // ignore: use_build_context_synchronously
  Navigator.pushReplacementNamed(context, '/');
}