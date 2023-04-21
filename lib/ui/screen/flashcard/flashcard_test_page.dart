import 'package:flashcard_project/ui/screen/flashcard/flashcard_test/result_page.dart';
import 'package:flashcard_project/ui/screen/flashcard/flashcard_test/test_page.dart';
import 'package:flutter/material.dart';
import 'package:flashcard_project/uilts.dart';
import 'package:dio/dio.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';
import 'package:collection/collection.dart';
import 'package:intl/intl.dart';

class FlashCardTestPage extends StatefulWidget {
    final List<String> questions;
    final List<String> answers;
    final String id;
    final String subtitle;
    const FlashCardTestPage({Key? key, required this.questions, required this.answers, required this.id, required this.subtitle}) : super(key: key);

    @override
    State<FlashCardTestPage> createState() => _FlashCardTestPageState();

    static navigateTo(context, List<String> questions, List<String> answers, String id, String subtitle) {
        Navigator.push(context, MaterialPageRoute(
            builder: (context) {
                return FlashCardTestPage(questions: questions, answers: answers, id: id, subtitle: subtitle);
            },
        ));
    }
}

class _FlashCardTestPageState extends State<FlashCardTestPage> {
    bool showResult = false;
    int curIdx = 0;
    String curQuestion = '';
    List<bool> correctness = [];
    List<double> similarity = [];
    List<dynamic> prevSimilarities = [];
    bool haveTakenBefore = false;
    String resultId = '';
    String scheduleId = '';
    String curReviewDate = '';
    int testTaken = 0;
    List<String> orderedQuestions = [];
    List<String> orderedAnswers = [];
    int nextReviewDay = 1;
    final user = FirebaseAuth.instance.currentUser;

    @override
    initState() {
        super.initState();
        showResult = false;
        curIdx = 0;
        curQuestion = '';
        curReviewDate = '';
        correctness = [];
        similarity = [];
        prevSimilarities = [];
        haveTakenBefore = false;
        orderedQuestions = [];
        orderedAnswers = [];
        resultId = '';
        scheduleId = '';
        testTaken = 0;
        nextReviewDay = 1;
        WidgetsBinding.instance.addPostFrameCallback((_){
            getPrevSimilarities();
        });
    }

    @override
    dispose() {
        super.dispose();
        showResult = false;
        curIdx = 0;
        curQuestion = '';
        curReviewDate = '';
        correctness = [];
        similarity = [];
        prevSimilarities = [];
        haveTakenBefore = false;
        orderedQuestions = [];
        orderedAnswers = [];
        resultId = '';
        scheduleId = '';
        testTaken = 0;
        nextReviewDay = 1;
    }

    void getPrevSimilarities() async{
        String userId = '';

        await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: user!.email.toString())
        .get()
        .then((snapshot) => {
            userId = snapshot.docs[0].reference.id.toString()
        });

        await FirebaseFirestore.instance
        .collection('schedules')
        .where('flashcard_id', isEqualTo: widget.id)
        .where('user', isEqualTo: userId)
        .get()
        .then((snapshot) {
            if(snapshot.docs.length > 0) {
                snapshot.docs.forEach((doc) {
                    setState(() {
                        scheduleId = doc.reference.id.toString();
                        curReviewDate = doc['date'];
                    });
                });                            
            }
        });

        await FirebaseFirestore.instance
        .collection('test_results')
        .where('flashcard', isEqualTo: widget.id)
        .where('user', isEqualTo: userId)
        .get()
        .then((snapshot) {
            if(snapshot.docs.length > 0) {
                snapshot.docs.forEach((doc) {
                    setState(() {
                        prevSimilarities = doc['similarity'];
                        testTaken = doc['testCount'];
                        haveTakenBefore = true;
                        resultId = doc.reference.id.toString();
                    });
                });

                var tmpPrevSimilarities = prevSimilarities.map((i) => i.toDouble()).toList();

                final Map<double, String> mappingsQ = {
                    for (int i = 0; i < tmpPrevSimilarities.length; i++)
                        tmpPrevSimilarities[i]: widget.questions[i]
                };

                final Map<double, String> mappingsA = {
                    for (int i = 0; i < tmpPrevSimilarities.length; i++)
                        tmpPrevSimilarities[i]: widget.answers[i]
                };                

                tmpPrevSimilarities.sort((a, b) => a.compareTo(b));
                var newQuestions = [
                    for (double number in tmpPrevSimilarities) mappingsQ[number] as String
                ];
                var newAnswers = [
                    for (double number in tmpPrevSimilarities) mappingsA[number] as String
                ];                

                setState(() {
                    orderedQuestions = newQuestions;
                    orderedAnswers = newAnswers;
                });
            }
        });
    }

    void submitAnswer(String answer) async{
        bool correct = false;

        Dio dio = new Dio();
        dio.options.headers['content-Type'] = "application/x-www-form-urlencoded";
        dio.options.headers["X-RapidAPI-Key"] = "0ecd282c8amsh6294092360c6ef4p13d4f6jsn568124761415";
        dio.options.headers["X-RapidAPI-Host"] = "twinword-text-similarity-v1.p.rapidapi.com";
        dio.options.headers["useQueryString"] = true;
        
        final res =  await dio.post(
            "https://twinword-text-similarity-v1.p.rapidapi.com/similarity/", 
            data: {'text1': haveTakenBefore ? orderedAnswers[curIdx] : widget.answers[curIdx], 'text2': answer}
        );

        if (res.data['similarity'] > 0.6)
            correct = true;
        
        setState(() {
            correctness.add(correct);
            curIdx += 1;
            similarity.add(res.data['similarity'].toDouble());
            showResult = !(curIdx < widget.questions.length);
        });

        if(curIdx == widget.questions.length) {
            String userId = '';

            await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: user!.email.toString())
            .get()
            .then((snapshot) => {
                userId = snapshot.docs[0].reference.id.toString()
            });

            if (!haveTakenBefore) {
                await FirebaseFirestore.instance.collection('test_results').add({
                    'correctness': correctness,
                    'flashcard': widget.id,
                    'similarity': similarity,
                    'taken_at': new DateTime.now().toString(),
                    'updated_at': '-',
                    'user': userId,
                    'testCount': 1,
                });

                var averageSimilarity = similarity.average;
                var nextReviewDate = 1.0 / sqrt(1) * (1 - exp(-1 * averageSimilarity));
                var dateInc = 1;
                DateTime today = new DateTime.now();

                if (nextReviewDate >= 0.8) {
                    dateInc = 4;
                } else if (nextReviewDate >= 0.5) {
                    dateInc = 3;
                } else if (nextReviewDate >= 0.3) {
                    dateInc = 2;
                } else {
                    dateInc = 1;
                }

                nextReviewDay = dateInc;

                DateTime reviewDate = new DateTime(today.year, today.month, today.day + dateInc);
                DateFormat formatter = DateFormat('dd/MM/yyyy');
                String formattedReviewDate = formatter.format(reviewDate);     

                await FirebaseFirestore.instance.collection('schedules').add({
                    'date': formattedReviewDate,
                    'flashcard_id': widget.id,
                    'title': widget.subtitle + ' review',
                    'type': 'review',
                    'user': userId,
                });            
            } else {
                var newSimilarities = [];
                double prevAverageSimilarity = 0;
                for (var i = 0; i < similarity.length; i++) {
                    double avgSimilarity = ((prevSimilarities[i] * testTaken) + similarity[i]) / (testTaken + 1);
                    newSimilarities.add(avgSimilarity);
                    prevAverageSimilarity = (prevAverageSimilarity + prevSimilarities[i]) as double;
                }
                var reorderedSimilarites = [
                    for (String idx in widget.answers) newSimilarities[orderedAnswers.indexOf(idx)]
                ];

                await FirebaseFirestore.instance.collection('test_results')
                .doc(resultId)
                .update({
                    'similarity': newSimilarities,
                    'testCount': testTaken + 1,
                    'updated_at': new DateTime.now().toString(),
                    'correctness': correctness,
                });
                
                var averageSimilarity = similarity.average;
                prevAverageSimilarity = (prevAverageSimilarity / similarity.length);
                var nextReviewDate = 1.0 / sqrt(1) * (1 - exp(-prevAverageSimilarity * averageSimilarity));
                var dateInc = 1;
                DateTime curReview = new DateFormat('dd/MM/yyyy').parse(curReviewDate);

                if (nextReviewDate >= 0.8) {
                    dateInc = 4;
                } else if (nextReviewDate >= 0.5) {
                    dateInc = 3;
                } else if (nextReviewDate >= 0.3) {
                    dateInc = 2;
                } else {
                    dateInc = 1;
                }

                nextReviewDay = dateInc;

                DateTime reviewDate = new DateTime(curReview.year, curReview.month, curReview.day + dateInc);
                DateFormat formatter = DateFormat('dd/MM/yyyy');
                String formattedReviewDate = formatter.format(reviewDate);

                await FirebaseFirestore.instance.collection('schedules')
                .doc(scheduleId)
                .update({
                    'date': formattedReviewDate,
                });
            }
        }
    }

    @override
    Widget build(BuildContext context) {
        if(haveTakenBefore && curIdx < orderedQuestions.length)
            curQuestion = orderedQuestions[curIdx];
        else if(curIdx < widget.questions.length)
            curQuestion = widget.questions[curIdx];

        if (showResult) {
            return ResultPage(
                subtitle: widget.subtitle,
                correctness: correctness,
                nextReviewDate: nextReviewDay.toString(),
            );
        } else {
            return TestPage(
                submitAnswer: submitAnswer, 
                curQuestion: curQuestion, 
                curIdx: curIdx,
                totalQuestion: widget.questions.length,
                subtitle: widget.subtitle,
            );
        }
    }
}