import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/cliente.dart';
import 'connect.dart';

Future<Cliente?> signIn(
    BuildContext context, String email, String senha) async {
  final prefs = await SharedPreferences.getInstance();

  var response = await connect(email, senha);

  if (response != false) {
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('email', email);
    await prefs.setString('senha', senha);

    return response;
  }

  return null;
}