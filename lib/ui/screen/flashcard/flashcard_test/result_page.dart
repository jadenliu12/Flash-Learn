import 'package:flashcard_project/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flashcard_project/uilts.dart';
import 'package:flashcard_project/main.dart';

class ResultPage extends StatefulWidget {
    final List<bool> correctness;
    final String subtitle;
    final String nextReviewDate;
    const ResultPage({Key? key, required this.subtitle, required this.correctness, required this.nextReviewDate}) : super(key: key);

    @override
    State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {

    @override
    initState() {
        super.initState();
    }

    @override
    Widget build(BuildContext context) {
        int correct = widget.correctness.where((item) => item == true).length;

        return Scaffold(
            appBar: PreferredSize(
                preferredSize: Size.fromHeight(55.0),
                child: AppBar(
                    title: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                            const Text('Flashcards', style: TextStyle(color: Colors.black)),
                            const SizedBox(height: 5),
                            Text(widget.subtitle, style: const TextStyle(fontSize: 15)),
                        ]
                    ),
                    backgroundColor: const Color(0xffacacac),
                    leading: GestureDetector(
                        child: Icon( Icons.arrow_back_ios ),
                        onTap: () {
                            MyStatefulWidget.navigateTo(context, chosenIdx: 0);
                        },
                    ),
                ),
            ),
            body: Padding(
                padding: const EdgeInsets.all(Insets.xtraLarge),
                child: Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                            const Text(
                                'Your Result',
                                style: TextStyle(fontSize: 40),
                            ),
                            const SizedBox(height: 40),
                            SizedBox(
                                height: 180,
                                width: 180,
                                child: ClipPath(
                                    clipper: StarClipper(14),
                                    child: Container(
                                        height: 150,
                                        color: const Color(0xff757575),
                                        child: Center(
                                            child: Text(
                                                correct.toString() + ' / ' + widget.correctness.length.toString(),
                                                style: const TextStyle(color: Color(0xffFFFFFF)),
                                            ),
                                        )
                                    ),
                                ),
                            ),
                            const SizedBox(height: 40),
                            const Text(
                                'Based on your current result, we have updated your learning shcedule to optimize your learning progress!',
                                style: TextStyle(fontSize: 20),
                                textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 40),
                            Text(
                                'Reminder:' + '\n' + '"' + widget.subtitle + '" \n review is due in ${widget.nextReviewDate} days' ,
                                style: TextStyle(fontSize: 20),
                                textAlign: TextAlign.center,
                            ),                            
                        ]
                    )
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
                                child: const Padding(
                                    padding: EdgeInsets.all(Insets.large),
                                    child: Center(
                                        child: Text(
                                            'SEE SCHEDULE',
                                            style: TextStyle(fontSize: 20),
                                        )
                                    )
                                )
                            ),
                            onTap: () {
                                MyStatefulWidget.navigateTo(context, chosenIdx: 1);
                            }
                        )
                    ),
                ),
            ),
        );
    }
}