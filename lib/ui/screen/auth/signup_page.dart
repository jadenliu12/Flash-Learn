import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flashcard_project/design_system.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  final VoidCallback showLoginPage;
  const SignUpPage({Key? key, required this.showLoginPage}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();

  Future signUp() async {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    ).then((value) => widget.showLoginPage);

    await addUserDetails(_emailController.text.trim(), _usernameController.text.trim());
  }

  Future addUserDetails(String email, String username) async {
    await FirebaseFirestore.instance.collection('users').add({
      'email': email,
      'username': username,
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
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
                                  hintText: 'email',
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
                        'Username: ',
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
                                controller: _usernameController,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'username',
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
                                  hintText: 'password',
                                ),
                              )
                          )
                      )
                  ),
                  const SizedBox(height: 20),
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: Insets.medium, horizontal: 170.0),
                      child: GestureDetector(
                        onTap: signUp,
                        child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xff757575),
                              border: Border.all(color: Colors.transparent),
                            ),
                            child: const Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: Insets.large, horizontal: Insets.xtraLarge),
                                  child: Text(
                                    'CREATE',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )
                            )
                        ),
                      )
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already have an account yet?",
                        style: TextStyle(fontSize: 12),
                      ),
                      GestureDetector(
                        onTap: widget.showLoginPage,
                        child: const Text(
                          " click here",
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
