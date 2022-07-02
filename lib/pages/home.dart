import 'package:flutter/material.dart';
import 'package:leilabeleiza/components/Agendamento.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("Seus agendamentos",
              style: TextStyle(color: Colors.white))),
      body: SingleChildScrollView(
        child: Column(
          children: const [
            Agendamento(),
            Agendamento(),
            Agendamento(),
            Agendamento(),
            Agendamento(),
            Agendamento(),
            Agendamento(),
            Agendamento(),
            Agendamento(),
            Agendamento(),
            Agendamento(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              backgroundColor: Colors.white,
              title: const Text("Criar agendamento"),
              content: Column(
                children: [
                  TextFormField(
                    
                  ),
                ],
              ),
            ),
          );
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
          side: const BorderSide(color: Color(0xFF810FCC)),
        ),
        child: const Icon(Icons.add),
      ),
    ));
  }
}
