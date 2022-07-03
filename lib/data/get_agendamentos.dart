import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/agendamento.dart';
import '../models/cliente.dart';

Future getAgendamentos(Cliente cliente) async {
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

  final response = await client
      .from('Agendamento')
      .select()
      .filter('id', 'in', appointmentIDs)
      .execute();

  for (var appointment in response.data) {
    appointments.add(Appointment(appointment['id'], appointment['titulo'],
        appointment['dataAgendamento'], appointment['horarioAgendamento']));
  }

  return Future.value(appointments);
}
