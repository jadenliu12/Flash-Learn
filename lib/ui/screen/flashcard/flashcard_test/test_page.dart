import 'package:flashcard_project/design_system.dart';
import 'package:flutter/material.dart';

typedef void StringCallback(String val);

class TestPage extends StatefulWidget {
    final StringCallback submitAnswer;
    final String curQuestion; 
    final int curIdx;
    final int totalQuestion;
    final String subtitle;

    const TestPage({
        Key? key, 
        required this.submitAnswer, 
        required this.curQuestion, 
        required this.curIdx, 
        required this.totalQuestion, 
        required this.subtitle,
    }) : super(key: key);

    @override
    State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
    var _inputController = TextEditingController();
    bool isLastQuestion = false;

    @override
    initState() {
        super.initState();
        isLastQuestion = false;
    }

    @override
    dispose() {
        super.dispose();
        _inputController.dispose();
        isLastQuestion = false;
    }

    @override
    Widget build(BuildContext context) {
        isLastQuestion = (widget.curIdx + 1) == widget.totalQuestion;

        return Scaffold(
            appBar: PreferredSize(
                preferredSize: Size.fromHeight(55.0),
                child: AppBar(
                    title: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                            Text(widget.subtitle),
                            const SizedBox(height: 5),
                            Text((widget.curIdx + 1).toString() + ' / ' + widget.totalQuestion.toString(), style: const TextStyle(fontSize: 15)),
                        ]
                    ),
                    backgroundColor: const Color(0xffacacac),
                    automaticallyImplyLeading: false,
                ),
            ),
            body: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                        Padding(
                            padding: const EdgeInsets.all(Insets.xtraLarge),
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
                                                        widget.curQuestion,
                                                        textAlign: TextAlign.left,
                                                        style: const TextStyle(
                                                            fontSize: 20,
                                                            color: Color(0xffFFFFFF),
                                                        ),
                                                    ),
                                                ),
                                            )
                                        )
                                    )
                                ),
                            ),
                        ),
                        Padding(
                            padding: const EdgeInsets.all(Insets.xtraLarge),
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
                                                    child: TextField(
                                                        controller: _inputController,
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(color: Color(0xffADADAD)),
                                                        decoration: InputDecoration(
                                                            border: InputBorder.none,
                                                            hintText: 'ENTER YOUR ANSWER HERE',
                                                            hintStyle: TextStyle(color: Color(0xffADADAD)),
                                                        ),
                                                    ),
                                                ),
                                            )
                                        ),
                                    )
                                ),
                            ),
                        )
                    ],
                )
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
                                child: Padding(
                                    padding: const EdgeInsets.all(Insets.large),
                                    child: Center(
                                        child: Text(
                                            isLastQuestion ? 'FINISH' : 'NEXT',
                                            style: const TextStyle(fontSize: 20),
                                        )
                                    )
                                )
                            ),
                            onTap: () {
                                widget.submitAnswer(_inputController.text.trim());
                                _inputController.clear();
                            }
                        )
                    ),
                ),
            ),
        );
    }
}