import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/agendamento.dart';
import '../models/cliente.dart';

Future<bool> saveAgendamento(Appointment agendamento, Cliente cliente) async {
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