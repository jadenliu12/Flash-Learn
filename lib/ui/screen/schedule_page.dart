import 'package:flutter/material.dart';
import 'package:flashcard_project/design_system.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flashcard_project/domain/model/schedule_model.dart';
import 'dart:collection';
import 'package:intl/intl.dart';

import '../../uilts.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({Key? key}) : super(key: key);

  @override
  State<SchedulePage> createState() => _SchedulePageState();

  static void navigateTo(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return const SchedulePage();
      },
    ));
  }
}

class _SchedulePageState extends State<SchedulePage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  var kSchedules;
  List<int> correctness = [];
  List<int> total = [];
  List<String> allFlashcardId = [];
  late final ValueNotifier<List<Schedule>> _selectedSchedules;
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    
    kSchedules = LinkedHashMap<DateTime, List<Schedule>>();
    _selectedDay = _focusedDay;
    correctness = [];
    total = [];
    allFlashcardId = [];

    WidgetsBinding.instance.addPostFrameCallback((_){
      getSchedules();
    });
    _selectedSchedules = ValueNotifier(_getSchedulesForDay(_selectedDay!));
  }

  @override
  void dispose() {
    _selectedSchedules.dispose();
    correctness = [];
    total = [];
    super.dispose();
  }

  void getSchedules() async {
    String userId = '';
    List<int> tmpCorrectness = [];
    List<int> tmpTotal = [];
    List<String> flashcardId = [];
    var tmpMap = LinkedHashMap<DateTime, List<Schedule>>();

    await FirebaseFirestore.instance
    .collection('users')
    .where('email', isEqualTo: user!.email.toString())
    .get()
    .then((snapshot) => {
        userId = snapshot.docs[0].reference.id.toString()
    });

    await FirebaseFirestore.instance
    .collection('schedules')
    .where('user', isEqualTo: userId)
    .get()
    .then((snapshot) => {
      snapshot.docs.forEach((doc) {
        Schedule newSchedule = Schedule(
          doc['date'],
          doc['flashcard_id'],
          doc['title'],
          doc['type'],
          doc['user'],
        );

        flashcardId.add(doc['flashcard_id']);
        DateTime tmpDate = new DateFormat('dd/MM/yyyy').parse(doc['date']);
        DateTime tmpDateUTC = new  DateTime.utc(tmpDate.year, tmpDate.month, tmpDate.day);

        if(tmpMap.containsKey(tmpDateUTC))
          tmpMap[tmpDateUTC]?.add(newSchedule);
        else
          tmpMap[tmpDateUTC] = [newSchedule];
      })
    });

    flashcardId.forEach((id) async {
      await FirebaseFirestore.instance.collection('test_results').where('flashcard', isEqualTo: id).get().then((snapshot) => {
        if (snapshot.docs.length == 0) {
          tmpTotal.add(0),
          tmpCorrectness.add(0),
        } else {
          tmpTotal.add(snapshot.docs[0]['correctness'].length),
          tmpCorrectness.add(snapshot.docs[0]['correctness'].where((item) => item == true).length),
        }
      });

      setState(() {
        correctness = tmpCorrectness;
        total = tmpTotal;
        allFlashcardId = new List.from(flashcardId.reversed);
      });
    });

    setState(() {
      kSchedules = tmpMap;
    });
  }

  List<Schedule> _getSchedulesForDay(DateTime day) {
    // Implementation example
    return kSchedules[day] ?? [];
  }

  List<Schedule> _getSchedulesForRange(DateTime start, DateTime end) {
    // Implementation example
    final days = daysInRange(start, end);

    return [
      for (final d in days) ..._getSchedulesForDay(d),
    ];
  }

  void _schedulesOnDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedSchedules.value = _getSchedulesForDay(selectedDay);
    }
  }

  void _schedulesOnRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    // `start` or `end` could be null
    if (start != null && end != null) {
      _selectedSchedules.value = _getSchedulesForRange(start, end);
    } else if (start != null) {
      _selectedSchedules.value = _getSchedulesForDay(start);
    } else if (end != null) {
      _selectedSchedules.value = _getSchedulesForDay(end);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Insets.large),
      child: Column(
        children: [
          TableCalendar<Schedule>(
            firstDay: kFirstDay,
            lastDay: kLastDay,
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            rangeStartDay: _rangeStart,
            rangeEndDay: _rangeEnd,
            calendarFormat: _calendarFormat,
            rangeSelectionMode: _rangeSelectionMode,
            eventLoader: _getSchedulesForDay,
            startingDayOfWeek: StartingDayOfWeek.monday,
            calendarStyle: const CalendarStyle(
              outsideDaysVisible: false,
            ),
            onDaySelected: _schedulesOnDaySelected,
            onRangeSelected: _schedulesOnRangeSelected,
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          const SizedBox(height: 20.0),
          Expanded(
            child: ValueListenableBuilder<List<Schedule>>(
              valueListenable: _selectedSchedules,
              builder: (context, value, _) {
                return ListView.builder(
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(Insets.small),
                      child: Container(
                        height: 100,
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12.0,
                          vertical: 4.0,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.transparent
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                          color: const Color(0xffFFFFFF),
                        ),
                        child: InkWell(
                          onTap: () => print('${value[index]}'),
                          child: Padding(
                            padding: const EdgeInsets.all(Insets.medium),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${DateFormat('EEEE').format(new DateFormat('dd/MM/yyyy').parse(value[index].date))}, ${value[index].date}',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontStyle: FontStyle.italic,
                                    color: Color(0xff8F9BB3),
                                  ),
                                ),
                                const SizedBox(height: 17.5),
                                Text(
                                  '${value[index].title}',
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontStyle: FontStyle.italic,
                                    color: Color(0xff222B45),
                                  ),
                                ),
                                const SizedBox(height: 17.5),
                                Text(
                                  'Your last review score is: ${correctness[allFlashcardId.indexOf(value[index].flashcard_id)]} / ${total[allFlashcardId.indexOf(value[index].flashcard_id)]}',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontStyle: FontStyle.italic,
                                    color: Color(0xff8F9BB3),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}