import 'package:flutter/material.dart';
import 'package:leilabeleiza/components/add_appointment.dart';
import 'package:leilabeleiza/components/agendamento.dart';
import 'package:leilabeleiza/data/get_agendamentos.dart';
import 'package:leilabeleiza/data/log_out.dart';
import 'package:leilabeleiza/models/cliente.dart';

class Home extends StatefulWidget {
  final Cliente? cliente;
  const Home({Key? key, this.cliente}) : super(key: key);

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
            actions: [
              IconButton(
                  onPressed: () async {
                    await logOut(context);
                  },
                  icon: const Icon(
                    Icons.logout,
                    color: Colors.white,
                  ))
            ],
          ),
          body: FutureBuilder(
            initialData: const [],
            future: getAgendamentos(widget.cliente!),
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
                  builder: (_) => AddAppointment(cliente: widget.cliente!));
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