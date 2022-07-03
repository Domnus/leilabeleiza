import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:leilabeleiza/models/agendamento.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<bool> _updateAgendamento(Appointment agendamento) async {
  final client = GetIt.instance<SupabaseClient>();

  final response = await client
      .from('Agendamento')
      .update({
        'dataAgendamento': agendamento.dataAgendamento,
        'horarioAgendamento': agendamento.horarioAgendamento
      })
      .eq('id', agendamento.id)
      .execute();

  if (response.hasError) {
    return Future.value(false);
  }

  return Future.value(true);
}

_showDateDialog(context, DateTime dataAgendamento) async {
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

_showTimeDialog(context, TimeOfDay horaAgendamento) async {
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

  @override
  Widget build(BuildContext context) {
    DateTime daquiDoisDias = DateTime.now().add(const Duration(days: 2));
    DateTime dataAgendamento =
        DateTime.parse(widget.agendamento.dataAgendamento!);

    bool buttonDisabled = daquiDoisDias.isAfter(dataAgendamento) ||
        daquiDoisDias.isAtSameMomentAs(dataAgendamento);

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
                Text("ID: ${widget.agendamento.id}"),
                Text(widget.agendamento.titulo!),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(widget.agendamento.dataAgendamento!),
                    Text(widget.agendamento.horarioAgendamento!),
                    TextButton(
                        onPressed: buttonDisabled
                            ? null
                            : () async {
                                await showDialog(
                                    context: context,
                                    builder: (_) => UpdateModal(
                                        agendamento: widget.agendamento));
                                setState(() {});
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

class UpdateModal extends StatefulWidget {
  final Appointment agendamento;
  const UpdateModal({Key? key, required this.agendamento}) : super(key: key);

  @override
  State<UpdateModal> createState() => _UpdateModalState();
}

class _UpdateModalState extends State<UpdateModal> {
  DateTime? _dateSelected = DateTime.now();
  TimeOfDay? _timeSelected = const TimeOfDay(hour: 00, minute: 00);

  @override
  Widget build(BuildContext context) {
    DateTime dataAgendamento =
        DateTime.parse(widget.agendamento.dataAgendamento!);
    TimeOfDay horaAgendamento = TimeOfDay.now();

    return AlertDialog(
      backgroundColor: Colors.white,
      title: const Text("Criar agendamento"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        borderRadius: BorderRadius.circular(2)),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(DateFormat('d/M/y')
                          .format(dataAgendamento)
                          .toString()),
                    ),
                  ),
                  onTap: () async {
                    DateTime selecionado = await _showDateDialog(context,
                        DateTime.parse(widget.agendamento.dataAgendamento!));

                    setState(() {
                      _dateSelected = selecionado;
                    });
                  }),
              InkWell(
                child: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      borderRadius: BorderRadius.circular(2)),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                        "${horaAgendamento.hour}:${horaAgendamento.minute}"),
                  ),
                ),
                onTap: () async {
                  TimeOfDay selecionado =
                      await _showTimeDialog(context, TimeOfDay.now());

                  setState(() {
                    _timeSelected = selecionado;
                  });
                },
              ),
            ],
          )
        ],
      ),
      actions: [
        TextButton(
          child: const Text("Cancelar"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        TextButton(
          child: const Text("Adicionar"),
          onPressed: () async {
            bool res = await _updateAgendamento(
              Appointment(
                widget.agendamento.id,
                '',
                _dateSelected.toString(),
                DateFormat.jm().format(
                  DateTime(
                    _dateSelected!.year,
                    _dateSelected!.month,
                    _dateSelected!.day,
                    _timeSelected!.hour,
                    _timeSelected!.minute,
                  ),
                ),
              ),
            );

            if (res) {
              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                  'Agendamento realizado com sucesso!',
                  style:
                      // ignore: use_build_context_synchronously
                      TextStyle(
                          // ignore: use_build_context_synchronously
                          color: Theme.of(context).colorScheme.secondary),
                ),
                duration: const Duration(milliseconds: 1500),
              ));

              // ignore: use_build_context_synchronously
              Navigator.pop(context);
            } else {
              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Ocorreu um erro! Tente novamente mais tarde.',
                    style: TextStyle(
                        // ignore: use_build_context_synchronously
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                  duration: const Duration(milliseconds: 1500),
                ),
              );
            }
          },
        ),
      ],
    );
  }
}
