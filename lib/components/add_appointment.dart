import 'package:flutter/Material.dart';
import 'package:intl/intl.dart';
import 'package:leilabeleiza/components/aviso.dart';
import 'package:leilabeleiza/components/button.dart';
import 'package:leilabeleiza/components/mensagem_SnackBar.dart';
import 'package:leilabeleiza/components/time_modal.dart';
import '../data/check_appointments.dart';
import '../data/save_agendamento.dart';
import '../models/agendamento.dart';
import '../models/cliente.dart';
import 'date_modal.dart';

class AddAppointment extends StatefulWidget {
  final Cliente cliente;
  const AddAppointment({Key? key, required this.cliente}) : super(key: key);

  @override
  State<AddAppointment> createState() => _AddAppointmentState();
}

class _AddAppointmentState extends State<AddAppointment> {
  final TextEditingController _tituloController = TextEditingController();
  DateTime? _dateSelected = DateTime.now();
  TimeOfDay? _timeSelected = TimeOfDay.now();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String dataFormatada =
        DateFormat('d/M/y').format(_dateSelected!).toString();
    int hora = _timeSelected!.hour;
    int minuto = _timeSelected!.minute;
    String horaFormatada =
        "${hora >= 10 ? hora.toString() : "0$hora"}:${minuto >= 10 ? minuto.toString() : "0$minuto"}";

    return AlertDialog(
      backgroundColor: Colors.white,
      title: const Center(child: Text("Criar agendamento")),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Título',
                    style: TextStyle(
                      fontSize: 20,
                    )),
              ),
              TextFormField(
                controller: _tituloController,
                obscureText: false,
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: const EdgeInsets.all(8),
                  hintText: 'Corte de cabelo',
                  hintStyle: const TextStyle(color: Colors.grey),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                          width: 1),
                      borderRadius: BorderRadius.circular(2)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2),
                      borderRadius: BorderRadius.circular(2)),
                ),
              ),
            ],
          ),
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
                              child: Text(dataFormatada)),
                        ),
                      ],
                    ),
                  ),
                  onTap: () async {
                    DateTime? selecionado =
                        await showDateDialog(context, DateTime.now());

                    setState(() {
                      if (selecionado != null) {
                        _dateSelected = selecionado;
                      }
                    });
                  }),
              InkWell(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
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
                ),
                onTap: () async {
                  TimeOfDay? selecionado =
                      await showTimeDialog(context, TimeOfDay.now());

                  setState(() {
                    if (selecionado != null) {
                      _timeSelected = selecionado;
                    }
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
        button(context, 'Adicionar', () async {
          if (_tituloController.text.isEmpty) {
            aviso(context, 'Digite um título para o serviço!');
          } else {
            Appointment agendamento = Appointment(
              null,
              _tituloController.text,
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
            );

            var check = await checkAppointments(agendamento, widget.cliente);

            if (check != null) {
              await showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text(
                      "Aviso",
                      style: TextStyle(fontSize: 20),
                    ),
                    content: Text(
                      "Você já tem um serviço agendado para a mesma semana. Deseja atualizar a data e horário para o mesmo dia?",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary),
                      textAlign: TextAlign.justify,
                    ),
                    actions: [
                      button(context, 'Não', () {
                        Navigator.pop(context);
                      }),
                      button(context, 'Sim', () {
                        agendamento = check;
                        Navigator.pop(context);
                      }),
                    ],
                  );
                },
              );
            }

            bool res = await saveAgendamento(
              agendamento,
              widget.cliente,
            );

            if (!mounted) return;

            if (res) {
              ScaffoldMessenger.of(context).showSnackBar(mensagemSnackBar(
                  context, 'Agendamento realizado com sucesso!'));

              Navigator.pop(context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(mensagemSnackBar(
                  context, 'Ocorreu um erro! Tente novamente mais tarde.'));
            }
          }
        })
      ],
    );
  }
}
