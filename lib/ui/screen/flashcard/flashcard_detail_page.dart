import 'package:flashcard_project/design_system.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flashcard_project/ui/screen/flashcard/flashcard_test_page.dart';
import 'package:flutter/material.dart';

class FlashCardDetailPage extends StatefulWidget {
    static navigateTo(context, String flashCardId, String flashCardSubtitle) {
    Navigator.push(context, MaterialPageRoute(
        builder: (context) {
        return FlashCardDetailPage(flashCardId: flashCardId, flashCardSubtitle: flashCardSubtitle);
        },
    ));
    }

    final String flashCardId;
    final String flashCardSubtitle;

    const FlashCardDetailPage({Key? key, required this.flashCardId, required this.flashCardSubtitle}) : super(key: key);

    @override
    State<FlashCardDetailPage> createState() => _FlashCardDetailPageState();
}

class _FlashCardDetailPageState extends State<FlashCardDetailPage> {
    List<String> questions = [];
    List<String> answers = [];
    List<bool> showAnswer = [];
    bool firstLoad = true;
    String id = '';

    Future getQuestionsAnswers() async {     
        if (firstLoad) {
            await FirebaseFirestore.instance
            .collection('flashcard_details')
            .where('flashcard', isEqualTo: widget.flashCardId)
            .get()
            .then((snapshot) {

                snapshot.docs.forEach((doc) {
                    doc['question'].forEach((q) {
                        questions.add(q);
                        showAnswer.add(false);
                    });
                    
                    doc['answer'].forEach((a) {
                        answers.add(a);
                    });

                    id = doc.reference.id.toString();
                });

                firstLoad = false;
            });
        }   
    }

    @override
    initState() {
        super.initState();
        firstLoad = true;
        questions = [];
        answers = [];
        showAnswer = [];
        id = '';
    }

    @override
    void dispose() {
        super.dispose();
        firstLoad = true;
        questions = [];
        answers = [];
        showAnswer = [];
        id = '';
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: PreferredSize(
                preferredSize: Size.fromHeight(55.0),
                child: AppBar(
                    title: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                            const Text('Flashcards', style: TextStyle(color: Colors.black)),
                            const SizedBox(height: 5),
                            Text(widget.flashCardSubtitle, style: const TextStyle(fontSize: 15)),
                        ]
                    ),
                    backgroundColor: const Color(0xffacacac),
                ),
            ),
            backgroundColor: const Color(0xffD9D9D9),
            body: Padding(
                padding: const EdgeInsets.all(Insets.large),
                child: FutureBuilder(
                    future: getQuestionsAnswers(),
                    builder: (context, snapshot) {
                        if(snapshot.connectionState == ConnectionState.done) {
                            return CustomScrollView(
                                slivers: [
                                    for (var i = 0; i < questions.length; i++ ) ...[
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
                                                                            child: Text(
                                                                                showAnswer[i] ? answers[i] : questions[i],
                                                                                textAlign: TextAlign.left,
                                                                                style: const TextStyle(
                                                                                    fontSize: 20,
                                                                                    color: Color(0xffFFFFFF),
                                                                                ),
                                                                            ),
                                                                        ),
                                                                    )
                                                                ),
                                                                onTap:() {
                                                                    setState(() {
                                                                        showAnswer[i] = !showAnswer[i];
                                                                    });
                                                                }
                                                            )
                                                        ),
                                                    ),
                                                );
                                            }, childCount: 1),
                                        )
                                    ]
                                ],
                            );
                        } else {
                            return Center(
                                child: CircularProgressIndicator()
                            );
                        }
                    }
                ),
            ),
            bottomNavigationBar: BottomAppBar(
                color: const Color(0xffACACAC),
                child: SizedBox(
                    height: 70,
                    child: Center(
                        child: InkWell(
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
                                            'START TEST',
                                            style: TextStyle(fontSize: 20),
                                        )
                                    )
                                )
                            ),
                            onTap: () {
                                FlashCardTestPage.navigateTo(
                                    context,
                                    questions,
                                    answers,
                                    id,
                                    widget.flashCardSubtitle,
                                );
                            }
                        )
                    ),
                ),
            ),
        );
    }
}
