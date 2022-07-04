import 'package:flutter/Material.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:leilabeleiza/components/time_modal.dart';

import '../data/update_agendamento.dart';
import '../models/agendamento.dart';
import 'button.dart';
import 'date_modal.dart';
import 'mensagem_SnackBar.dart';

class UpdateAppointmentModal extends StatefulWidget {
  final Appointment agendamento;
  const UpdateAppointmentModal({Key? key, required this.agendamento})
      : super(key: key);

  @override
  State<UpdateAppointmentModal> createState() => _UpdateAppointmentModalState();
}

class _UpdateAppointmentModalState extends State<UpdateAppointmentModal> {
  DateTime dateSelected = DateTime.now();
  TimeOfDay timeSelected = TimeOfDay.now();
  String horaFormatada = '';

  @override
  void initState() {
    dateSelected = DateTime.parse(widget.agendamento.dataAgendamento!);
    final horaCrua = widget.agendamento.horarioAgendamento?.split(":");
    timeSelected = TimeOfDay(
        hour: int.parse(horaCrua![0]), minute: int.parse(horaCrua[1]));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    horaFormatada =
        "${timeSelected.hour >= 10 ? timeSelected.hour.toString() : "0${timeSelected.hour}"}:${timeSelected.minute >= 10 ? timeSelected.minute.toString() : "0${timeSelected.minute}"}";

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
                        await showDateDialog(context, dateSelected);

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
                        child: Text(horaFormatada),
                      ),
                    ),
                  ],
                ),
                onTap: () async {
                  TimeOfDay selecionado =
                      await showTimeDialog(context, timeSelected);

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
        button(context, 'Cancelar', () {
          Navigator.pop(context);
        }),
        button(context, 'Atualizar', () async {
          Appointment agendamento = Appointment(
            widget.agendamento.id,
            '',
            dateSelected.toString(),
            DateFormat.jm().format(
              DateTime(
                dateSelected.year,
                dateSelected.month,
                dateSelected.day,
                timeSelected.hour,
                timeSelected.minute,
              ),
            ),
          );

          bool res = await updateAgendamento(agendamento);

          if (!mounted) return;
          if (res) {
            ScaffoldMessenger.of(context).showSnackBar(mensagemSnackBar(
                context, 'Agendamento atualizado com sucesso!'));

            Navigator.pop(context);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(mensagemSnackBar(
                context, 'Ocorreu um erro! Tente novamente mais tarde.'));
          }
        }),
      ],
    );
  }
}
