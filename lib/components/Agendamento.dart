import 'package:flutter/material.dart';
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
                          ? () {
                              null;
                              showDialog(
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
                                            "Você só pode alterar um serviço com 2 dias de antecedência.\nCaso queira alterar a data nos contacte por telefone.",
                                            textAlign: TextAlign.justify,
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary),
                                          ),
                                        ],
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text("OK"),
                                        )
                                      ],
                                    );
                                  });
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
                            : null,
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
