import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<bool> cadastrarCliente(String nome, String email, String senha) async {
  final client = GetIt.instance<SupabaseClient>();
  final response = await client.from('Cliente').insert({
    'nome': nome,
    'email': email,
    'senha': senha,
  }).execute();

  if (response.error != null) {
    return Future.value(false);
  }

  return Future.value(true);
}