import 'package:flutter/Material.dart';
import 'package:intl/intl.dart';
import 'package:leilabeleiza/components/time_modal.dart';

import '../data/update_agendamento.dart';
import '../models/agendamento.dart';
import 'date_modal.dart';

class UpdateAppointmentModal extends StatefulWidget {
  final Appointment agendamento;
  const UpdateAppointmentModal({Key? key, required this.agendamento}) : super(key: key);

  @override
  State<UpdateAppointmentModal> createState() => _UpdateAppointmentModalState();
}

class _UpdateAppointmentModalState extends State<UpdateAppointmentModal> {
  DateTime? _dateSelected = DateTime.now();
  TimeOfDay? _timeSelected = const TimeOfDay(hour: 00, minute: 00);

  @override
  Widget build(BuildContext context) {
    DateTime dataAgendamento =
        DateTime.parse(widget.agendamento.dataAgendamento!);
    TimeOfDay horaAgendamento = TimeOfDay.now();

    return AlertDialog(
      backgroundColor: Colors.white,
      title: const Text("Atualizar agendamento"),
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
                    DateTime selecionado = await showDateDialog(context,
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
                      await showTimeDialog(context, TimeOfDay.now());

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
            bool res = await updateAgendamento(
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