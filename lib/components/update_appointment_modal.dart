import 'package:flutter/Material.dart';
import 'package:intl/intl.dart';
import 'package:leilabeleiza/components/time_modal.dart';

import '../data/update_agendamento.dart';
import '../models/agendamento.dart';
import 'date_modal.dart';

class UpdateAppointmentModal extends StatefulWidget {
  final Appointment agendamento;
  const UpdateAppointmentModal({Key? key, required this.agendamento})
      : super(key: key);

  @override
  State<UpdateAppointmentModal> createState() => _UpdateAppointmentModalState();
}

class _UpdateAppointmentModalState extends State<UpdateAppointmentModal> {
  @override
  Widget build(BuildContext context) {
    DateTime? dateSelected =
        DateTime.parse(widget.agendamento.dataAgendamento!);

    final horaCrua = widget.agendamento.horarioAgendamento?.split(":");
    TimeOfDay? timeSelected = TimeOfDay(
        hour: int.parse(horaCrua![0]), minute: int.parse(horaCrua[1]));

    return AlertDialog(
      backgroundColor: Colors.white,
      title: const Center(child: Text("Atualizar agendamento")),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        const Text("Data"),
                        Container(
                          margin: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              borderRadius: BorderRadius.circular(2)),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(DateFormat('d/M/y')
                                .format(dateSelected)
                                .toString()),
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () async {
                    DateTime selecionado =
                        await showDateDialog(context, dateSelected!);

                    setState(() {
                      dateSelected = selecionado;
                    });
                  }),
              InkWell(
                child: Column(
                  children: [
                    const Text("Horário"),
                    Container(
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          borderRadius: BorderRadius.circular(2)),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child:
                            Text("${timeSelected.hour}:${timeSelected.minute}"),
                      ),
                    ),
                  ],
                ),
                onTap: () async {
                  TimeOfDay selecionado =
                      await showTimeDialog(context, timeSelected!);

                  setState(() {
                    timeSelected = selecionado;
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
                dateSelected.toString(),
                DateFormat.jm().format(
                  DateTime(
                    dateSelected!.year,
                    dateSelected!.month,
                    dateSelected!.day,
                    timeSelected!.hour,
                    timeSelected!.minute,
                  ),
                ),
              ),
            );

            if (!mounted) return;

            if (res) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                  'Agendamento realizado com sucesso!',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.secondary),
                ),
                duration: const Duration(milliseconds: 1500),
              ));

              Navigator.pop(context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Ocorreu um erro! Tente novamente mais tarde.',
                    style: TextStyle(
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
