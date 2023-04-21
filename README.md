# Flash-Learn

## Basic Informations
Motivation and Purpose:  
> As a student, I found myself continuously studying and gaining more and more
information each day. Some concepts were harder than other to understand and
sometimes it is difficult to determine how frequent should I review the concepts in order
to understand it using the least required time. Moreover, one of the biggest problems of
us student is that we sometimes cannot manage our time very well and most of us waited
until the very last moment to study for an important test. But sometimes even if we have
prepared our very best before the exam, there are just some concepts that we might
forget. Hence, is it possible for us to maximize our learning schedule and our way of
learning in order to maximize our memory?  

> Currently, all the flashcards application that are available in the internet are just
static flashcard apps, which mean that the user would be the one to set everything,
starting from flashcard creation and until scheduling for reviews. Moreover, some of
these flashcard applications doesn’t even randomize the order of the flashcard each time
the user took a test or review the concepts. Hence, I found out that the current flashcards
application isn’t a very reliable tool to use in order to help us improve our ability to
memorize these concepts better.

Tech Stack: **Flutter + Dart + Firebase**  
Concepts Implemented: [Adaptive Teaching](https://arxiv.org/pdf/1805.08322.pdf), [Spaced Repetition Optimization](https://www.pnas.org/doi/epdf/10.1073/pnas.1815156116), [Memorize Algorithm](https://github.com/Networks-Learning/Memorize),    
Features:
- Login, sign-up and logout
- Flashcard collection (on-going and completed)
- ADd new flashcard
- Flashcard review + result
- Schedule page
- Account page

## System Design and Overall Architecture
![image](https://user-images.githubusercontent.com/78072759/233538504-dec22be1-1a22-49c1-85d7-dc4eab5b63ed.png)

## System Implementation
What makes this implementation different from the existing research is that I
will be introducing similarity into the equation. So instead of just labeling the learner’s
answer purely by correct or wrong, I will be using a similarity threshold to determine
the correctness of the answer.

1. Modified Adaptive Teaching Algorithm  
![image](https://user-images.githubusercontent.com/78072759/233539185-f417bd49-bb89-4838-9bbf-b06e9b11e45a.png)

2. Modified Memorize Algorithm
```math
m(t) = e^{-n(t) * t_{lastReview}}
```
```math
u(t) = q^{-1/2} * (1 - m(t))
```

## Application Screenshots

### Login Screen
![image](https://user-images.githubusercontent.com/78072759/233540204-67b8da57-8740-422e-8e28-32c3cabbd245.png)

### Sign-up Screen
![image](https://user-images.githubusercontent.com/78072759/233540215-cf7f4917-74e9-41d0-a310-d0c0056d00c6.png)

### Flashcard Collection Screen (On-going)
![image](https://user-images.githubusercontent.com/78072759/233540230-78d6e6d3-ab9e-4530-ab3b-5bf49000449b.png)

### Flashcard Collection Screen (Completed)
![image](https://user-images.githubusercontent.com/78072759/233540665-363d9c3f-af54-44ec-8273-4e4e1508e493.png)

### Add New Flashcard Screen (Step 1)
![image](https://user-images.githubusercontent.com/78072759/233540261-25259b06-ca7d-4739-b600-16f3d214e65c.png)

### Add New Flashcard Screen (Step 2)
![image](https://user-images.githubusercontent.com/78072759/233540271-4213d20f-d865-492d-9587-52deef9acbf7.png)

### Calendar Screen
![image](https://user-images.githubusercontent.com/78072759/233540688-5498d121-1678-4cef-a966-1f1cbd3b5976.png)

### Account Screen
![image](https://user-images.githubusercontent.com/78072759/233540291-90ddaf96-8d44-425d-ba31-dd9c5b6ff456.png)
