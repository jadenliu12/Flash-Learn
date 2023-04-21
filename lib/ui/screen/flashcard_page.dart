import 'package:flashcard_project/design_system.dart';
import 'package:flashcard_project/domain/model/flashcard_model.dart';
import 'package:flashcard_project/ui/screen/flashcard/flashcard_detail_page.dart';
import 'package:flashcard_project/ui/screen/flashcard/flashcard_add_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FlashCardPage extends StatefulWidget {
  const FlashCardPage({Key? key}) : super(key: key);

  @override
  State<FlashCardPage> createState() => _FlashCardPageState();

  static void navigateTo(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return const FlashCardPage();
      },
    ));
  }
}

class _FlashCardPageState extends State<FlashCardPage> {
  final user = FirebaseAuth.instance.currentUser;
  List<FlashCard> onGoingFlashCardList = [];
  List<FlashCard> completedFlashCardList = [];

  Future getFlashCards(String status) async {
    String userId = '';

    await FirebaseFirestore.instance
      .collection('users')
      .where('email', isEqualTo: user!.email.toString())
      .get()
      .then((snapshot) => {
        userId = snapshot.docs[0].reference.id.toString()
      });
      
    await FirebaseFirestore.instance
      .collection('flashcards')
      .where('user', isEqualTo: userId)
      .where('status', isEqualTo: status)
      .get()
      .then((snapshot) {
        snapshot.docs.forEach((doc) {
          FlashCard newCard = FlashCard(
            doc['due_date'],
            doc['status'],
            doc['subtitle'],
            doc['title'],
            doc['user'],
            doc.reference.id.toString(),
          );

          if (status == 'On Going')
            onGoingFlashCardList.add(newCard);
          else if (status == 'Completed')
            completedFlashCardList.add(newCard);
        });
      });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    onGoingFlashCardList = [];
    completedFlashCardList = [];
  }

  TabBar get _tabBar => const TabBar(
    indicatorColor: Color(0xff666666),
      tabs: [
        Tab(text: 'On Going'),
        Tab(text: 'Completed'),
      ]
  );

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xffD9D9D9),
        appBar: AppBar(
          bottom: PreferredSize(
            preferredSize: _tabBar.preferredSize,
            child: Material(
              color: const Color(0xffbababa),
              child: _tabBar,
            ),
          ),
          title: const Text('Flashcards', style: TextStyle(color: Colors.black)),
          backgroundColor: const Color(0xffacacac),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 20),
              child: IconButton(
                icon: const Icon(Icons.add),
                tooltip: 'Add new flashcard',
                onPressed: () {
                  FlashCardAddPage.navigateTo(context);
                }
              ),
            )
          ],
          automaticallyImplyLeading: false,
        ),
        body: Padding(
          padding: const EdgeInsets.all(Insets.large),
          child: TabBarView(
            children: [
              Scaffold(
                backgroundColor: const Color(0xffD9D9D9),
                body: FutureBuilder(
                    future: getFlashCards('On Going'),
                    builder: (context, snapshot) {
                      if(snapshot.connectionState == ConnectionState.done) {
                        if (onGoingFlashCardList.length == 0) return const Center(child: Text("You don't have any on going flashcards"));
                        return CustomScrollView(
                          slivers: [
                            for (var flashCard in onGoingFlashCardList) ...[
                              SliverList(
                                  delegate: SliverChildBuilderDelegate((context, index) {
                                    return Padding(
                                        padding: const EdgeInsets.all(Insets.small),
                                        child: Row(
                                            children: [
                                              Text(
                                                flashCard.title,
                                                style: const TextStyle(
                                                  color: Color(0xffADA7C1),
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 20,
                                                ),
                                              ),
                                              const Spacer(),
                                              const Text(
                                                'Start Review',
                                                style: TextStyle(
                                                  color: Color(0xff838383),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              )
                                            ]
                                        )
                                    );
                                  }, childCount: 1)
                              ),
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
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          'Due: ' + flashCard.due_date,
                                                          textAlign: TextAlign.left,
                                                          style: const TextStyle(
                                                            fontSize: 10,
                                                            color: Color(0xffC7C3DB),
                                                          ),
                                                        ),
                                                        const SizedBox(height: 20),
                                                        Text(
                                                          flashCard.subtitle,
                                                          textAlign: TextAlign.left,
                                                          style: const TextStyle(
                                                            fontSize: 20,
                                                            color: Color(0xffFFFFFF),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                              ),
                                              onTap:() {
                                                FlashCardDetailPage.navigateTo(
                                                  context,
                                                  flashCard.id,
                                                  flashCard.subtitle,
                                                );
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
                      }
                      if (snapshot.hasError) return const Text("Something wrong happend");
                      return const Center(child: CircularProgressIndicator());
                    }
                ),
              ),
              Scaffold(
                backgroundColor: const Color(0xffD9D9D9),
                body: FutureBuilder(
                    future: getFlashCards('Completed'),
                    builder: (context, snapshot) {
                      if(snapshot.connectionState == ConnectionState.done) {
                        if (completedFlashCardList.length == 0) return const Center(child: Text("You don't have any completed flashcards"));
                        return CustomScrollView(
                          slivers: [
                            for (var flashCard in completedFlashCardList) ...[
                              SliverList(
                                  delegate: SliverChildBuilderDelegate((context, index) {
                                    return Padding(
                                        padding: const EdgeInsets.all(Insets.small),
                                        child: Row(
                                            children: [
                                              Text(
                                                flashCard.title,
                                                style: const TextStyle(
                                                  color: Color(0xffADA7C1),
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ]
                                        )
                                    );
                                  }, childCount: 1)
                              ),
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
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          'Due: ' + flashCard.due_date,
                                                          textAlign: TextAlign.left,
                                                          style: TextStyle(
                                                            fontSize: 10,
                                                            color: Color(0xffC7C3DB),
                                                          ),
                                                        ),
                                                        const SizedBox(height: 20),
                                                        Text(
                                                          flashCard.subtitle,
                                                          textAlign: TextAlign.left,
                                                          style: const TextStyle(
                                                            fontSize: 20,
                                                            color: Color(0xffFFFFFF),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                              ),
                                              onTap:() {
                                                FlashCardDetailPage.navigateTo(
                                                  context,
                                                  flashCard.id,
                                                  flashCard.subtitle,
                                                );
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
                      }
                      if (snapshot.hasError) return const Text("Something wrong happend");
                      return const Center(child: CircularProgressIndicator());
                    }
                ),
              ),
            ],
          ),
        )
      )
    );
  }
}
