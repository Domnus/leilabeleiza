import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:leilabeleiza/components/Agendamento.dart';
import 'package:leilabeleiza/models/agendamento.dart';
import 'package:leilabeleiza/models/cliente.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future _getAppointments(Cliente cliente) async {
  List appointmentIDs = [];
  List appointments = [];
  final client = GetIt.instance<SupabaseClient>();

  final agendamentos = await client
      .from('AgendamentosCliente')
      .select()
      .eq('clienteID', cliente.clienteID)
      .execute();


  for (var appointment in agendamentos.data) {
    appointmentIDs.add(appointment['agendamentoID']);
  }

  final response = await client.from('Agendamento').select().filter('id', 'in', appointmentIDs).execute();

  for (var appointment in response.data) {
    appointments.add(Appointment(appointment['id'], appointment['titulo'],
        appointment['dataAgendamento'], appointment['horarioAgendamento']));
  }

  return Future.value(appointments);
}

Future<bool> _saveAgendamento(Appointment agendamento, Cliente cliente) async {
  final client = GetIt.instance<SupabaseClient>();

  final agendamentoResponse = await client.from('Agendamento').insert({
    'titulo': agendamento.titulo,
    'dataAgendamento': agendamento.dataAgendamento,
    'horarioAgendamento': agendamento.horarioAgendamento
  }).execute();

  if (agendamentoResponse.hasError) {
    return Future.value(false);
  }

  final dataAgendamento = agendamentoResponse.data;

  final agendamentosResponse = await client.from('AgendamentosCliente').insert({
    "agendamentoID": dataAgendamento[0]['id'],
    "clienteID": cliente.clienteID
  }).execute();

  if (agendamentosResponse.hasError) {
    return Future.value(false);
  }

  return Future.value(true);
}

_showDateDialog(context) async {
  DateTime? dataEscolhida = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
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

_showTimeDialog(context) async {
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

  return horarioEscolhido;
}

class Home extends StatefulWidget {
  final Cliente cliente;
  const Home({Key? key, required this.cliente}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Text(
              "Seus agendamentos",
              style: TextStyle(color: Colors.white),
            ),
          ),
          body: FutureBuilder(
            initialData: const [],
            future: _getAppointments(widget.cliente),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  break;

                case ConnectionState.waiting:
                  return Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      CircularProgressIndicator(),
                      Text('Carregando')
                    ],
                  ));

                case ConnectionState.active:
                  break;

                case ConnectionState.done:
                  List? agendamentos = snapshot.data as List?;

                  if (agendamentos == null || agendamentos.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                            Text("Nenhum agendamento encontrado!",
                                style: TextStyle(fontSize: 20)),
                            Text("Clique no botão abaixo para fazer o",
                                style: TextStyle(fontSize: 20)),
                            Text("seu primeiro agendamento!",
                                style: TextStyle(fontSize: 20))
                          ],
                        ),
                      ),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: agendamentos.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Agendamento(
                          agendamento: agendamentos[index],
                        );
                      },
                    );
                  }
              }
              return const Center(
                child: Text("Erro inesperado, tente novamente mais tarde."),
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              await showDialog(
                  context: context,
                  builder: (_) => Modal(cliente: widget.cliente));
              setState(() {});
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
              side: const BorderSide(color: Color(0xFF810FCC)),
            ),
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}

class Modal extends StatefulWidget {
  final Cliente cliente;
  const Modal({Key? key, required this.cliente}) : super(key: key);

  @override
  State<Modal> createState() => _ModalState();
}

class _ModalState extends State<Modal> {
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
                scrollPadding: const EdgeInsets.all(0),
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
                decoration: InputDecoration(
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
                    DateTime selecionado = await _showDateDialog(context);

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
                  TimeOfDay selecionado = await _showTimeDialog(context);

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

            bool res = await _saveAgendamento(
              Appointment(null, _tituloController.text,
                  _dateSelected.toString(), format.format(tempTime).toString()),
              widget.cliente,
            );

            if (res) {
              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                  'Agendamento realizado com sucesso!',
                  style:
                      // ignore: use_build_context_synchronously
                      TextStyle(color: Theme.of(context).colorScheme.secondary),
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
