import 'package:flashcard_project/design_system.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

typedef void StringCallback(String val);

class AddFirstStep extends StatefulWidget {
    final VoidCallback showSecondPage;
    final StringCallback setCardDocId;
    final StringCallback setDate;
    final StringCallback setTitle;
    const AddFirstStep({Key? key, required this.showSecondPage, required this.setCardDocId, required this.setDate, required this.setTitle}) : super(key: key);

    @override
    State<AddFirstStep> createState() => _AddFirstStepState();
}

class _AddFirstStepState extends State<AddFirstStep> {
    final user = FirebaseAuth.instance.currentUser;
    final _titleController = TextEditingController();
    final _subtitleController = TextEditingController();
    final _dueDateController = TextEditingController();

    @override
    initState() {
        super.initState();
    }

    @override
    dispose() {
        super.dispose();
        _titleController.dispose();
        _subtitleController.dispose();
        _dueDateController.dispose();
    }

    Future AddFlashCard() async {
        String userId = '';
        String docId = '';

        await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: user!.email.toString())
            .get()
            .then((snapshot) => {
                userId = snapshot.docs[0].reference.id.toString()
            });

        await FirebaseFirestore.instance.collection('flashcards').add({
            'due_date': _dueDateController.text.trim(),
            'status': 'On Going',
            'subtitle': _subtitleController.text.trim(),
            'title': _titleController.text.trim(),
            'user': userId,
        }).then((docRef) => {
                widget.setCardDocId(docRef.id)
            }
        );

        widget.setDate(_dueDateController.text.trim());
        widget.setTitle( _subtitleController.text.trim());
        widget.showSecondPage();
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            backgroundColor: const Color(0xffD9D9D9),
            appBar: PreferredSize(
                preferredSize: Size.fromHeight(55.0),
                child: AppBar(
                    title: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                            Text('Flashcards', style: TextStyle(color: Colors.black)),
                            SizedBox(height: 5),
                            Text('Add New Flashcards', style: const TextStyle(fontSize: 15)),
                        ]
                    ),
                    backgroundColor: const Color(0xffacacac),
                ),
            ),
            body: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                        const Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                            padding: EdgeInsets.only(left: 65),
                            child: Text(
                                'Title: ',
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
                                        controller: _titleController,
                                        decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            hintText: 'title',
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
                                'Subtitle: ',
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
                                        controller: _subtitleController,
                                        decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            hintText: 'subtitle',
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
                                'Due Date: ',
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
                                        controller: _dueDateController,
                                        decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            hintText: 'dd/mm/yyyy',
                                        ),
                                    )
                                )
                            )
                        ),
                    ]
                ),
            ),
            bottomNavigationBar: BottomAppBar(
                color: const Color(0xffACACAC),
                child: GestureDetector(
                    onTap: AddFlashCard,
                    child: SizedBox(
                        height: 70,
                        child: Center(
                            child: Container(
                                height: 46,
                                width: 400,
                                decoration: BoxDecoration(
                                    color: const Color(0xffD9D9D9),
                                    border: Border.all(color: Colors.transparent),
                                    borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: const Padding(
                                    padding: EdgeInsets.all(Insets.large),
                                    child: Center(
                                        child: Text(
                                            'NEXT',
                                            style: TextStyle(fontSize: 20),
                                        )
                                    )
                                )
                            ),
                        ),
                    ),
                )
            ),
        );
    }
}