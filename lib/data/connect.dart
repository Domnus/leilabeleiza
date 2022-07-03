import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/cliente.dart';

Future connect(String email, String senha) async {
  final client = GetIt.instance<SupabaseClient>();

  final res = await client
      .from('Cliente')
      .select()
      .eq('email', email)
      .single()
      .execute();

  if (res.hasError) {
    return Future.value(res.error);
  }

  final data = res.data;

  if (data != null) {
    if (data['email'] == email && data['senha'] == senha) {
      return Future.value(Cliente(data['id'], data['nome'], data['email']));
    }
  }

  return Future.value(false);
}
