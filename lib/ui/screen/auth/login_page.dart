import 'package:firebase_auth/firebase_auth.dart';
import 'package:flashcard_project/design_system.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback showRegisterPage;
  const LoginPage({Key? key, required this.showRegisterPage}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future signIn() async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffD9D9D9),
      body: Column(
        children: <Widget>[
          Expanded(
            child: SizedBox(
              height: 400,
              width: 400,
              child: Image.asset('assets/images/title.png'),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 65),
                    child: Text(
                      'Email: ',
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: Insets.medium, horizontal: 50.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xffEBEBEB),
                      border: Border.all(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(20)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: Insets.xtraLarge),
                      child: TextField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Email',
                        ),
                      )
                    )
                  )
                ),
                const SizedBox(height: 15),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 65),
                    child: Text(
                      'Password: ',
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: Insets.medium, horizontal: 50.0),
                    child: Container(
                        decoration: BoxDecoration(
                            color: const Color(0xffEBEBEB),
                            border: Border.all(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(20)
                        ),
                        child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: Insets.xtraLarge),
                            child: TextField(
                              controller: _passwordController,
                              obscureText: true,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Password',
                              ),
                            )
                        )
                    )
                ),
                const SizedBox(height: 20),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: Insets.medium, horizontal: 170.0),
                    child: GestureDetector(
                      onTap: signIn,
                      child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xff757575),
                            border: Border.all(color: Colors.transparent),
                          ),
                          child: const Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: Insets.large, horizontal: Insets.xtraLarge),
                                child: Text(
                                  'SIGN IN',
                                  style: TextStyle(color: Colors.white),
                                ),
                              )
                          )
                      )
                    )
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account yet?",
                      style: TextStyle(fontSize: 12),
                    ),
                    GestureDetector(
                      onTap: widget.showRegisterPage,
                      child: const Text(
                        " sign up here",
                        style: TextStyle(fontSize: 12, color: Color(0xff397689)),
                      ),
                    )
                  ],
                )
              ]
            ),
          ),
        ],
      ),
    );
  }
}
