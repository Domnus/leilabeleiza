import '../components/Agendamento.dart';

class Cliente {
  String? nome;
  String? email;
  List<Agendamento>? agendamentos;

  Cliente(this.nome, this.email, this.agendamentos);
}
