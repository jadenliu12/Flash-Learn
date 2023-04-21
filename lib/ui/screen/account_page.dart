import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flashcard_project/design_system.dart';
import 'package:flutter/material.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();

  static void navigateTo(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return const AccountPage();
      },
    ));
  }
}

class _AccountPageState extends State<AccountPage> {
  final user = FirebaseAuth.instance.currentUser;
  String username = '';

  Future getUsername() async {
    await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: user!.email.toString())
        .get()
        .then((snapshot) => {
          snapshot.docs.forEach((doc) {
            username = doc['username'];
          })
        });
  }

  Future signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getUsername(),
      builder: (context, snapshot) {
        return Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  height: 300.0,
                  decoration: const BoxDecoration(
                    color: Color(0xffD9D9D9),
                    border: Border(
                      bottom: BorderSide(width: 1, color: Colors.black)
                    )
                  ),
                  child: Center(
                    child: SizedBox(
                      height: 400,
                      width: 400,
                      child: Image.asset('assets/images/title.png'),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: const Color(0xffD9D9D9),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:  [
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.only(left: 65),
                              child: Text(
                                'Username',
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          Container(
                            height: 46,
                            width: 347,
                            decoration: BoxDecoration(
                              color: const Color(0xffEBEBEB),
                              border: Border.all(color: Colors.transparent),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(Insets.large),
                              child: Text(
                                username
                              )
                            )
                          ),
                          const SizedBox(height: 20.0),
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.only(left: 65),
                              child: Text(
                                'Email',
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          Container(
                            height: 46,
                            width: 347,
                            decoration: BoxDecoration(
                              color: const Color(0xffEBEBEB),
                              border: Border.all(color: Colors.transparent),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Padding(
                                padding: const EdgeInsets.all(Insets.large),
                                child: Text(
                                    user!.email.toString()
                                )
                            )
                          ),
                          const SizedBox(height: 70.0),
                          Padding(
                              padding: const EdgeInsets.symmetric(vertical: Insets.medium, horizontal: 100.0),
                              child: GestureDetector(
                                  onTap: signOut,
                                  child: Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0xff757575),
                                        border: Border.all(color: Colors.transparent),
                                      ),
                                      child: const Center(
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(vertical: Insets.large, horizontal: Insets.xtraLarge),
                                            child: Text(
                                              'LOG OUT',
                                              style: TextStyle(color: Colors.white),
                                            ),
                                          )
                                      )
                                  )
                              )
                          ),
                        ],
                    ),
                  ),
                ),
              ],
            ),
            // Profile image
            Positioned(
              top: 202.5,
              child: Container(
                height: 195.0,
                width: 195.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xffACACAC),
                  border: Border.all(color: Colors.black, width: 3),
                ),
                child: Center(
                  child: Image.asset('assets/images/user.png', height: 150, width: 150,),
                )
              ),
            )
          ],
        );
      }
    );
  }

}
