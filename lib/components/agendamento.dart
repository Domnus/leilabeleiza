import 'package:flutter/material.dart';
import 'package:leilabeleiza/components/aviso.dart';
import 'package:leilabeleiza/components/update_appointment_modal.dart';
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

  @override
  Widget build(BuildContext context) {
    DateTime daquiDoisDias = DateTime.now().add(const Duration(days: 2));
    DateTime dataAgendamento =
        DateTime.parse(widget.agendamento.dataAgendamento!);

    bool buttonDisabled = daquiDoisDias.isAfter(dataAgendamento) ||
        daquiDoisDias.isAtSameMomentAs(dataAgendamento);

    final ano = DateTime.parse(widget.agendamento.dataAgendamento!).year;
    final mes = DateTime.parse(widget.agendamento.dataAgendamento!).month;
    final dia = DateTime.parse(widget.agendamento.dataAgendamento!).day;
    final String dataFormatada = "$dia/$mes/$ano";

    final horaCrua = widget.agendamento.horarioAgendamento?.split(":");
    final horaProcessada = TimeOfDay(
      hour: int.parse(horaCrua![0]),
      minute: int.parse(horaCrua[1]),
    );
    final String horaFormatada =
        "${horaProcessada.hour >= 10 ? horaProcessada.hour.toString() : "0${horaProcessada.hour}"}:${horaProcessada.minute >= 10 ? horaProcessada.minute.toString() : "0${horaProcessada.minute}"} ${horaProcessada.period.name.toUpperCase()}";

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).colorScheme.primary),
              borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "ID: ${widget.agendamento.id}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Text(widget.agendamento.titulo!),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(dataFormatada),
                    Text(horaFormatada),
                    TextButton(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        side: MaterialStateProperty.all<BorderSide>(
                          BorderSide(
                              color: Theme.of(context).colorScheme.primary),
                        ),
                      ),
                      onPressed: buttonDisabled
                          ? () {
                              null;
                              aviso(context,
                                  'Voc?? s?? pode alterar um servi??o com at?? 2 dias de anteced??ncia.\nCaso queira alterar a data ou hor??rio nos contacte por telefone.');
                            }
                          : () async {
                              await showDialog(
                                  context: context,
                                  builder: (_) => UpdateAppointmentModal(
                                      agendamento: widget.agendamento));
                              setState(() {});
                            },
                      child: Text(
                        'Editar data',
                        style: buttonDisabled
                            ? const TextStyle(color: Colors.grey)
                            : const TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                )
              ],
            ),
          )),
    );
  }
}