import 'package:flutter/material.dart';

showTimeDialog(context, TimeOfDay horaAgendamento) async {
  TimeOfDay? horarioEscolhido = await showTimePicker(
    context: context,
    initialTime: horaAgendamento,
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

  return horarioEscolhido;
}