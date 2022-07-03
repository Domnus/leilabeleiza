import 'dart:io';
import 'package:flutter/material.dart';
import 'package:leilabeleiza/data/sign_in.dart';
import '../components/mensagem_SnackBar.dart';
import '../data/cadastrar_cliente.dart';
import '../models/cliente.dart';

class Cadastro extends StatefulWidget {
  const Cadastro({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CadastroState();
  }
}

class CadastroState extends State<Cadastro> {
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  late bool _senhaVisivel = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: MediaQuery.of(context).size.width,
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 1,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.arrow_back)),
                        const Text('Voltar',
                            style:
                                TextStyle(color: Colors.white, fontSize: 24)),
                      ],
                    ),
                  ),
                  const Text('Cadastro',
                      style: TextStyle(color: Colors.white, fontSize: 32)),
                  Expanded(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Nome',
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          fontSize: 28,
                                        )),
                                    TextField(
                                      controller: _nomeController,
                                      obscureText: false,
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary),
                                      cursorColor: Colors.white,
                                      decoration: InputDecoration(
                                        hintText: 'Bento Carlos',
                                        hintStyle: const TextStyle(
                                            color: Colors.white70),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                              width: 2),
                                          borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(4.0),
                                              topRight: Radius.circular(4.0)),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                              width: 2),
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(4.0),
                                            topRight: Radius.circular(4.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Email',
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          fontSize: 28,
                                        )),
                                    TextField(
                                      controller: _emailController,
                                      obscureText: false,
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary),
                                      cursorColor: Colors.white,
                                      decoration: InputDecoration(
                                        hintText: 'bcsilva49@gmail.com',
                                        hintStyle: const TextStyle(
                                            color: Colors.white70),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                              width: 2),
                                          borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(4.0),
                                              topRight: Radius.circular(4.0)),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                              width: 2),
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(4.0),
                                            topRight: Radius.circular(4.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Senha',
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          fontSize: 28),
                                    ),
                                    TextField(
                                      controller: _senhaController,
                                      obscureText: !_senhaVisivel,
                                      enableSuggestions: false,
                                      autocorrect: false,
                                      cursorColor: Colors.white,
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary),
                                      decoration: InputDecoration(
                                        hintText: '●●●●●●●●●●●●●●●',
                                        hintStyle: const TextStyle(
                                            color: Colors.white70),
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                              _senhaVisivel
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary),
                                          onPressed: () {
                                            setState(
                                              () {
                                                _senhaVisivel = !_senhaVisivel;
                                              },
                                            );
                                          },
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                            width: 2,
                                          ),
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(4.0),
                                            topRight: Radius.circular(4.0),
                                          ),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                            width: 2,
                                          ),
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(4.0),
                                            topRight: Radius.circular(4.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: ElevatedButton(
                              onPressed: () async {
                                try {
                                  final result = await InternetAddress.lookup(
                                    'google.com',
                                  );
                                  if (result.isNotEmpty &&
                                      result[0].rawAddress.isNotEmpty) {
                                    bool result = await cadastrarCliente(
                                      _nomeController.text,
                                      _emailController.text,
                                      _senhaController.text,
                                    );

                                    if (!mounted) return;
                                    if (result) {
                                      Cliente? cliente = await signIn(
                                        context,
                                        _emailController.text,
                                        _senhaController.text,
                                      );

                                      if (!mounted) return;
                                      if (cliente != null) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          mensagemSnackBar(context,
                                              'Cadastro realizado com sucesso!'),
                                        );

                                        Navigator.pushReplacementNamed(
                                          context,
                                          '/extractCliente',
                                          arguments: cliente,
                                        );
                                      }
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        mensagemSnackBar(context,
                                            'Ocorreu um erro! Tente novamente mais tarde.'),
                                      );
                                    }
                                  }
                                } on SocketException catch (_) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    mensagemSnackBar(
                                        context, 'Sem conexão com a internet!'),
                                  );
                                }
                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<
                                        Color>(
                                    Theme.of(context).colorScheme.secondary),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(20.0),
                                child: Text(
                                  'Cadastrar',
                                  style: TextStyle(
                                    fontSize: 24,
                                    color: Color(0xFF810FCC),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
