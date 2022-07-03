import 'package:flutter/Material.dart';
import 'package:intl/intl.dart';
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
  TimeOfDay? _timeSelected = const TimeOfDay(hour: 00, minute: 00);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: const Text("Criar agendamento"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            children: [
              const Text('Título',
                  style: TextStyle(
                    fontSize: 20,
                  )),
              TextFormField(
                controller: _tituloController,
                obscureText: false,
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: const EdgeInsets.all(8),
                  hintText: 'Pintura de cabelo',
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
                          .format(_dateSelected!)
                          .toString()),
                    ),
                  ),
                  onTap: () async {
                    DateTime selecionado =
                        await showDateDialog(context, DateTime.now());

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
                    child: Text(DateFormat('H:m')
                        .format(
                          DateTime(
                              _dateSelected!.year,
                              _dateSelected!.month,
                              _dateSelected!.day,
                              _timeSelected!.hour,
                              _timeSelected!.minute),
                        )
                        .toString()),
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
            DateTime tempTime = DateFormat("hh:mm")
                .parse("${_timeSelected!.hour}:${_timeSelected!.minute}");
            var format = DateFormat("h:mm a");

            Appointment agendamento = Appointment(null, _tituloController.text,
                _dateSelected.toString(), format.format(tempTime).toString());

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
                        "Parece que você está tentando adicionar um serviço, mas já existe um marcado para menos de 1 semana. Deseja mudar a data do serviço atual para o já existente?",
                        style: TextStyle(
                            fontSize: 20,
                            color: Theme.of(context).colorScheme.primary),
                        textAlign: TextAlign.justify,
                      ),
                      actions: [
                        TextButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            side: MaterialStateProperty.all<BorderSide>(
                              BorderSide(
                                  color: Theme.of(context).colorScheme.primary),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            "Não",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        TextButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            side: MaterialStateProperty.all<BorderSide>(
                              BorderSide(
                                  color: Theme.of(context).colorScheme.primary),
                            ),
                          ),
                          onPressed: () {
                            agendamento = check;
                            Navigator.pop(context);
                          },
                          child: const Text(
                            "Sim",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    );
                  });
            }

            bool res = await saveAgendamento(
              agendamento,
              widget.cliente,
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