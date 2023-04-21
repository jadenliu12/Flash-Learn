class FlashCard {
  final String due_date;
  final String status;
  final String title;
  final String subtitle;
  final String user;
  final String id;

  FlashCard(this.due_date, this.status, this.title, this.subtitle, this.user, this.id);
}

class FlashCardDetail {
  final List<dynamic> question;
  final List<dynamic> answer;
  final String flashcard;

  FlashCardDetail(this.question, this.answer, this.flashcard);
}