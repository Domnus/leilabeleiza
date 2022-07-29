import 'package:flutter/material.dart';
import '../models/cliente.dart';
import 'home.dart';

class ExtractClient extends StatelessWidget {
  const ExtractClient({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Cliente client = ModalRoute.of(context)!.settings.arguments as Cliente;

    return Home(cliente: client);
  }
}