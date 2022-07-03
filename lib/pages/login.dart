import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/connect.dart';
import '../models/cliente.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return LoginState();
  }
}

class LoginState extends State<Login> {
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  late bool _senhaVisivel = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: MediaQuery.of(context).size.width,
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: SafeArea(
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 1,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'Cabeleleila Leila',
                        style: TextStyle(color: Colors.white, fontSize: 32),
                      ),
                    ),
                    Expanded(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.75,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                    hintStyle:
                                        const TextStyle(color: Colors.white70),
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
                            Column(
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
                                    hintStyle:
                                        const TextStyle(color: Colors.white70),
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
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (!mounted) return;

                                  final prefs =
                                      await SharedPreferences.getInstance();

                                  var response = await connect(
                                      _emailController.text,
                                      _senhaController.text);

                                  if (response != false) {
                                    await prefs.setBool('isLoggedIn', true);
                                    await prefs.setString(
                                        'email', _emailController.text);
                                    await prefs.setString(
                                        'senha', _senhaController.text);

                                    if (!mounted) return;
                                    Navigator.pushReplacementNamed(
                                      context,
                                      '/extractCliente',
                                      arguments: response,
                                    );
                                  }

                                  if (!mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        response,
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary),
                                      ),
                                      duration:
                                          const Duration(milliseconds: 1500),
                                    ),
                                  );
                                },
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<
                                          Color>(
                                      Theme.of(context).colorScheme.secondary),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(20.0),
                                  child: Text(
                                    'ENTRAR',
                                    style: TextStyle(
                                      fontSize: 24,
                                      color: Color(0xFF810FCC),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Não tem uma conta?',
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/cadastro');
                                  },
                                  child: Text(
                                    'Cadastre-se',
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                              ],
                            )
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
      ),
    );
  }
}
