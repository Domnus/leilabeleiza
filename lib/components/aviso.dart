import 'package:flutter/material.dart';

import 'button.dart';

aviso(BuildContext context, String text) async {
  return await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text(
          "Aviso",
          style: TextStyle(fontSize: 20),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              textAlign: TextAlign.justify,
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
          ],
        ),
        actions: [
          button(context, 'OK', () {
            Navigator.pop(context);
          }),
        ],
      );
    },
  );
}
