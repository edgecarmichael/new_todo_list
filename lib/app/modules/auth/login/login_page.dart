import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/app/core/notifier/app_listener_notifier.dart';
import 'package:todo_list/app/core/ui/app_messages.dart';
import 'package:todo_list/app/core/widget/app_field.dart';
import 'package:todo_list/app/core/widget/todo_logo.dart';
import 'package:todo_list/app/modules/auth/login/login_controller.dart';
import 'package:validatorless/validatorless.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailEC = TextEditingController();
  final _passwordEC = TextEditingController();
  final _emailFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    AppListenerNotifier(changeNotifier: context.read<LoginController>())
        .listener(
            context: context,
            everCallBack: (notifier, listenerInstance) {
              if (notifier is LoginController) {
                if (notifier.hasInfo) {
                  AppMessages.of(context).showInfo(notifier.infoMessage!);
                }
              }
            },
            successCallBack: (notifier, listenerInstance) {
              print('Login efetuado com sucesso');
            });
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<LoginController>(context);
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
                minWidth: constraints.maxWidth,
              ),
              child: IntrinsicHeight(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(height: 60),
                    TodoLogo(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 20),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            AppField(
                              focusNode: _emailFocus,
                              controller: _emailEC,
                              label: "E-mail",
                              validator: Validatorless.multiple([
                                Validatorless.required('E-mail obrigatótio'),
                                Validatorless.email('E-mail invalido')
                              ]),
                            ),
                            SizedBox(height: 20),
                            AppField(
                              controller: _passwordEC,
                              obscureText: true,
                              label: "Senha",
                              validator: Validatorless.multiple([
                                Validatorless.required('Senha obrigatória'),
                                Validatorless.min(6,
                                    'Senha deve conter pelo menos 6 caracteres'),
                              ]),
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    if (_emailEC.text.isNotEmpty) {
                                      context
                                          .read<LoginController>()
                                          .forgotPassword(_emailEC.text);
                                    } else {
                                      _emailFocus.requestFocus();
                                      AppMessages.of(context).showError(
                                          'Digite um e-mail para recuperar a senha');
                                    }
                                  },
                                  child: Text("Esqueceu sua senha?"),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    final formValid =
                                        _formKey.currentState?.validate() ??
                                            false;
                                    if (formValid) {
                                      final email = _emailEC.text;
                                      final password = _passwordEC.text;
                                      context
                                          .read<LoginController>()
                                          .login(email, password);
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12.0, horizontal: 24),
                                    child: Text("Login"),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              width: 2,
                              color: Colors.grey.withAlpha(50),
                            ),
                          ),
                          color: Color(0xffF0F3F7),
                        ),
                        child: Column(
                          children: [
                            SizedBox(height: 30),
                            Container(),
                            SignInButton(
                              Buttons.Google,
                              text: 'Continue com o google',
                              padding: const EdgeInsets.all(5),
                              shape: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none,
                              ),
                              onPressed: () {
                                context.read<LoginController>().googleLogin();
                              },
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Não tem conta?"),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pushNamed("/register");
                                  },
                                  child: Text("Cadastre-se"),
                                )
                              ],
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
