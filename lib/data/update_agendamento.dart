import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/agendamento.dart';

Future<bool> updateAgendamento(Appointment agendamento) async {
  final client = GetIt.instance<SupabaseClient>();

  final response = await client
      .from('Agendamento')
      .update({
        'dataAgendamento': agendamento.dataAgendamento,
        'horarioAgendamento': agendamento.horarioAgendamento
      })
      .eq('id', agendamento.id)
      .execute();

  if (response.hasError) {
    return Future.value(false);
  }

  return Future.value(true);
}
