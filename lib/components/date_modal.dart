import 'package:flutter/material.dart';

showDateDialog(context, DateTime dataAgendamento) async {
  DateTime? dataEscolhida = await showDatePicker(
    context: context,
    initialDate: dataAgendamento,
    firstDate: DateTime.now(),
    lastDate: DateTime(2200),
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: Theme.of(context).colorScheme.primary,
          ),
          dialogBackgroundColor: Colors.white,
        ),
        child: child!,
      );
    },
  );

  return dataEscolhida;
}