import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:leilabeleiza/models/agendamento.dart';

class Agendamento extends StatefulWidget {
  final Appointment agendamento;
  const Agendamento({Key? key, required this.agendamento}) : super(key: key);

  @override
  State<Agendamento> createState() => _AgendamentoState();
}

class _AgendamentoState extends State<Agendamento> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = const TimeOfDay(hour: 00, minute: 00);

  String? hora, minuto, horario;

  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  _showModal(context) async {
    DateTime? dataEscolhida = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2021),
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

    TimeOfDay? horarioEscolhido = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 00, minute: 00),
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
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.blueAccent),
              borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(widget.agendamento.titulo!),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(widget.agendamento.dataAgendamento!),
                    Text(widget.agendamento.horarioAgendamento!),
                    TextButton(
                        onPressed: () {
                          _showModal(context);
                        },
                        child: const Text('Editar data')),
                  ],
                )
              ],
            ),
          )),
    );
  }
}
