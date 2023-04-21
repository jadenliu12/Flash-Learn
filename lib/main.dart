import 'package:flashcard_project/ui/screen/account_page.dart';
import 'package:flashcard_project/ui/screen/auth_page.dart';
import 'package:flashcard_project/ui/screen/flashcard_page.dart';
import 'package:flashcard_project/ui/screen/schedule_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static void navigateTo(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return const MyApp();
      },
    ));
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flash Learn',
      home: MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  final int chosenIdx;
  const MyStatefulWidget({Key? key, this.chosenIdx = 0}) : super(key: key);

  static void navigateTo(BuildContext context, {int chosenIdx = 0}) {
    Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return MyStatefulWidget(chosenIdx: chosenIdx);
      },
    ));
  }

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    FlashCardPage(),
    SchedulePage(),
    AccountPage(),
  ];

  static const List<Widget> _appbarOptions = <Widget>[
    Text('Flashcards'),
    Text('Schedule', style: TextStyle(color: Colors.black)),
    Text('Account', style: TextStyle(color: Colors.black)),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.chosenIdx;
  }

  @override
  Widget build(BuildContext context) {
    return  StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            backgroundColor: const Color(0xffD9D9D9),
            appBar: _selectedIndex > 0 ? AppBar(
              title: _appbarOptions.elementAt(_selectedIndex),
              backgroundColor: const Color(0xffacacac),
              automaticallyImplyLeading: false,
            ) : null,
            body: Center(
              child: _widgetOptions.elementAt(_selectedIndex),
            ),
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: const Color(0xffACACAC),
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Flashcard',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.business),
                  label: 'Schedule',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.school),
                  label: 'Account',
                ),
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: const Color(0xffD9D9D9),
              onTap: _onItemTapped,
            ),
          );
        } else {
          return const AuthPage();
        }
      }
    );
  }
}

