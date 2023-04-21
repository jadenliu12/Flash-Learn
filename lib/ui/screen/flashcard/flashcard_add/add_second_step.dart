import 'package:flashcard_project/design_system.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flashcard_project/main.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddSecondStep extends StatefulWidget {
    final VoidCallback showFirstPage;
    final String docId;
    final String date;
    final String title;
    const AddSecondStep({Key? key, required this.showFirstPage, required this.docId, required this.date, required this.title}) : super(key: key);

    @override
    State<AddSecondStep> createState() => _AddSecondStepState();
}

class _AddSecondStepState extends State<AddSecondStep> {
    List<String> questions = [];
    List<String> answers = [];
    List<bool> isFinishInputted = [];
    List<bool> showAnswer = [];
    int numOfCards = 0;
    bool finishedInputQna = true;
    bool isQuestion = true;
    var _inputController = TextEditingController();
    final user = FirebaseAuth.instance.currentUser;

    @override
    initState() {
        super.initState();
        questions = [];
        answers = [];
        isFinishInputted = [];
        showAnswer = [];
        numOfCards = 0;
        finishedInputQna = true;
        isQuestion = true;
    }

    @override
    dispose() {
        super.dispose();
        questions = [];
        answers = [];
        isFinishInputted = [];
        showAnswer = [];
        numOfCards = 0;
        finishedInputQna = true;
        isQuestion = true;
        _inputController.dispose();
    }

    void AddNewCard() {
        if (finishedInputQna) 
            setState(() {
                numOfCards += 1;
                finishedInputQna = false;
                isFinishInputted.add(false);
                showAnswer.add(false);
            });
    }

    void SubmitField(String value) {
        if (isQuestion) {
            questions.add(_inputController.text.trim());

            setState(() {
                isQuestion = !isQuestion;
                _inputController.clear();
            });
        } else {
            answers.add(_inputController.text.trim());

            setState(() {
                finishedInputQna = true;
                isQuestion = !isQuestion;
                _inputController.clear();
                isFinishInputted.last = !isFinishInputted.last;
            });
        }
    }

    Future AddFlashCardDetail() async {
        if (answers.length == questions.length && questions.length > 0) {
            String userId = '';
            String flashcardId = '';

            await FirebaseFirestore.instance
                .collection('users')
                .where('email', isEqualTo: user!.email.toString())
                .get()
                .then((snapshot) => {
                    userId = snapshot.docs[0].reference.id.toString()
                });

            await FirebaseFirestore.instance.collection('flashcard_details').add({
                'answer': answers,
                'flashcard': widget.docId,
                'question': questions,
            })
            .then((docRef) => {
                flashcardId = docRef.id
            });

            await FirebaseFirestore.instance.collection('schedules').add({
                'date': widget.date,
                'flashcard_id': flashcardId,
                'title': widget.title + ' deadline',
                'type': 'deadline',
                'user': userId,
            });

            MyStatefulWidget.navigateTo(context, chosenIdx: 0);
        }
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
                    leading: GestureDetector(
                        child: Icon( Icons.arrow_back_ios ),
                        onTap: widget.showFirstPage,
                    ),
                ),
            ),
            body: Padding(
                padding: const EdgeInsets.all(Insets.xtraLarge),
                child: CustomScrollView(
                    slivers: [
                        for (var i = 0; i < numOfCards; i++) ...[
                            SliverList(
                                delegate: SliverChildBuilderDelegate((context, index) {
                                    return Padding(
                                        padding: const EdgeInsets.all(Insets.small),
                                        child: Center(
                                            child: Card(
                                                elevation: 0,
                                                shape: RoundedRectangleBorder(
                                                    side: const BorderSide(
                                                        color: Color(0xffADA7C1),
                                                    ),
                                                    borderRadius: BorderRadius.circular(4.0),
                                                ),
                                                color: const Color(0xff343141),
                                                child: InkWell(
                                                    child: SizedBox(
                                                        height: 100,
                                                        width: MediaQuery.of(context).size.width,
                                                        child: Padding(
                                                            padding: const EdgeInsets.all(Insets.xtraLarge),
                                                            child: Center(
                                                                child: isFinishInputted[i] ? Text(
                                                                        showAnswer[i] ? answers[i] : questions[i],
                                                                        textAlign: TextAlign.left,
                                                                        style: const TextStyle(
                                                                            fontSize: 20,
                                                                            color: Color(0xffFFFFFF),
                                                                        ),
                                                                    ) : TextField(
                                                                    controller: _inputController,
                                                                    textAlign: TextAlign.center,
                                                                    style: TextStyle(color: Color(0xffADADAD)),
                                                                    decoration: InputDecoration(
                                                                        border: InputBorder.none,
                                                                        hintText: isQuestion ? 'ENTER QUESTION' : 'ENTER ANSWER',
                                                                        hintStyle: TextStyle(color: Color(0xffADADAD)),
                                                                    ),
                                                                    onSubmitted: SubmitField,
                                                                )
                                                            ),
                                                        )
                                                    ),
                                                    onTap:() {
                                                        if (isFinishInputted[i]) {
                                                            setState(() {
                                                                showAnswer[i] = !showAnswer[i];
                                                            });
                                                        }
                                                    }
                                                )
                                            ),
                                        ),
                                    );
                                }, childCount: 1)
                            )
                        ],
                        SliverList(
                            delegate: SliverChildBuilderDelegate((context, index) {
                                return GestureDetector(
                                    onTap: AddNewCard,
                                    child: Padding(
                                        padding: EdgeInsets.all(Insets.medium),
                                        child: DottedBorder(
                                            dashPattern: [6, 3],
                                            borderType: BorderType.RRect,
                                            radius: Radius.circular(20),
                                            strokeWidth: 1,
                                            child: Container(
                                                height: 100,
                                                color: Colors.transparent,
                                                child: const Padding(
                                                    padding: EdgeInsets.all(Insets.large),
                                                    child: Center(
                                                        child: Text(
                                                            'ADD NEW FLASHCARD',
                                                            style: TextStyle(
                                                                fontSize: 20,
                                                                color: const Color(0xffADADAD),
                                                            ),
                                                        )
                                                    )
                                                )
                                            ),
                                        )
                                    ),
                                );
                            }, childCount: 1)
                        ),
                    ]
                ),
            ),
            bottomNavigationBar: BottomAppBar(
                color: const Color(0xffACACAC),
                child: GestureDetector(
                    onTap: AddFlashCardDetail,
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
                                            'FINISH',
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