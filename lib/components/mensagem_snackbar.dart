import 'package:flutter/material.dart';

mensagemSnackBar(BuildContext context, String mensagem) {
  return SnackBar(
    content: Text(
      mensagem,
      style: TextStyle(color: Theme.of(context).colorScheme.secondary),
    ),
    duration: const Duration(milliseconds: 1500),
  );
}
