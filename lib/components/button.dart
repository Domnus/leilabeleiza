import 'package:flutter/material.dart';

button(BuildContext context, String text, Function onPressed) {
  return TextButton(
    style: ButtonStyle(
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      side: MaterialStateProperty.all<BorderSide>(
        BorderSide(color: Theme.of(context).colorScheme.primary),
      ),
    ),
    child: Text(
      text,
      style: const TextStyle(color: Colors.black),
    ),
    onPressed: () {
      onPressed();
    },
  );
}
