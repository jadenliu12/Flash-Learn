import 'package:flashcard_project/ui/screen/flashcard/flashcard_add/add_first_step.dart';
import 'package:flashcard_project/ui/screen/flashcard/flashcard_add/add_second_step.dart';
import 'package:flutter/material.dart';

class FlashCardAddPage extends StatefulWidget {
    const FlashCardAddPage({Key? key}) : super(key: key);

    @override
    State<FlashCardAddPage> createState() => _FlashCardAddPageState();

    static navigateTo(context) {
        Navigator.push(context, MaterialPageRoute(
            builder: (context) {
            return FlashCardAddPage();
            },
        ));
    }
}

class _FlashCardAddPageState extends State<FlashCardAddPage> {
    bool showFirstPage = true;
    String cardDocId = '';
    String title = '';
    String date = '';

    void togglePage() {
        setState(() {
            showFirstPage = !showFirstPage;
        });
    }

    void setCardDocId(String id) {
        setState(() {
            cardDocId = id;
        });
    }

    void setTitle(String t) {
        setState(() {
            title = t;
        });
    }    

    void setDate(String d) {
        setState(() {
            date = d;
        });
    }

    @override
    Widget build(BuildContext context) {
        if(showFirstPage) {
            return AddFirstStep(showSecondPage: togglePage, setCardDocId: setCardDocId, setDate: setDate, setTitle: setTitle);
        } else {
            return AddSecondStep(showFirstPage: togglePage, docId: cardDocId, date: date, title: title);
        }
    }
}