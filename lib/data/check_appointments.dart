import 'package:leilabeleiza/data/get_agendamentos.dart';

import '../models/agendamento.dart';
import '../models/cliente.dart';

Future checkAppointments(Appointment appointment, Cliente cliente) async {
  final List<Appointment> agendamentos = await getAgendamentos(cliente);

  for (var agendamento in agendamentos) {
    DateTime dataAgendamentoExistente =
        DateTime.parse(agendamento.dataAgendamento!);
    DateTime dataAgendamentoNovo = DateTime.parse(appointment.dataAgendamento!);

    if (dataAgendamentoNovo
        .add(const Duration(days: 7))
        .isAfter(dataAgendamentoExistente)) {
      return Appointment(appointment.id, appointment.titulo,
          dataAgendamentoExistente.toString(), agendamento.horarioAgendamento);
    }
  }

  return null;
}