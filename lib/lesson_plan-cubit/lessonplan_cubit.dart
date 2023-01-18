import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

part 'lessonplan_state.dart';

class LessonPlanCubit extends Cubit<LessonPlanState> {
  LessonPlanCubit(this.localizations) : super(const LessonPlanInitial()) {
    lessonPlanDaysAndHours = [
      localizations.monday,
      localizations.tuesday,
      localizations.wednesday,
      localizations.thursday,
      localizations.friday,
      localizations.lessons,
    ];
    _loadHours(initialValueFirstParameter, initialValueSecondParameter);
  }
  final AppLocalizations localizations;
  List<String> lessonPlanDaysAndHours = [];
  int _whichDayIsActiveForUndoSetNewPlan =
      initialValueOfWhichDayIsActiveForUndoSetNewPlan;
  List<String> _lessonPlanListForUndoSetNewPlan =
      initialValueOfLessonPlanListForUndoSetNewPlan;

  Future<void> _loadDays(bool lessonPlanOrChangePlan, int index) async {
    final int whichDayIsActive = index;
    final prefs = await SharedPreferences.getInstance();
    final List<String> currentDayPlan =
        prefs.getStringList(lessonPlanKeys[whichDayIsActive]) ??
            defaultLessonPlan;
    final List<List<Color>> cardColorList =
        _loadCardColorList(whichDayIsActive);
    emit(LessonPlan(localizations, lessonPlanDaysAndHours, cardColorList,
        currentDayPlan, whichDayIsActive, lessonPlanOrChangePlan));
  }

  void _loadHours(bool lessonPlanOrChangePlan, int index) {
    final int whichDayIsActive = index;
    final List<String> currentDayPlan = [
      '${lessonHours[0].hour}.${lessonHours[0].minute}-${lessonHours[1].hour}.${lessonHours[1].minute}',
      '${lessonHours[2].hour}.${lessonHours[2].minute}-${lessonHours[3].hour}.${lessonHours[3].minute}',
      '${lessonHours[4].hour}.${lessonHours[4].minute}-${lessonHours[5].hour}.${lessonHours[5].minute}',
      '${lessonHours[6].hour}.${lessonHours[6].minute}-${lessonHours[7].hour}.${lessonHours[7].minute}',
      '${lessonHours[8].hour}.${lessonHours[8].minute}-${lessonHours[9].hour}.${lessonHours[9].minute}',
      '${lessonHours[10].hour}.${lessonHours[10].minute}-${lessonHours[11].hour}.${lessonHours[11].minute}',
      '${lessonHours[12].hour}.${lessonHours[12].minute}-${lessonHours[13].hour}.${lessonHours[13].minute}',
      '${lessonHours[14].hour}.${lessonHours[14].minute}-${lessonHours[15].hour}.${lessonHours[15].minute}',
    ];
    final List<List<Color>> cardColorList =
        _loadCardColorList(whichDayIsActive);

    emit(LessonPlan(localizations, lessonPlanDaysAndHours, cardColorList,
        currentDayPlan, whichDayIsActive, lessonPlanOrChangePlan));
  }

  void changePlanLayout(int index, bool lessonPlanOrChangePlan) {
    if (index == 5) {
      _loadHours(lessonPlanOrChangePlan, index);
      print('dzień$index');
    } else {
      _loadDays(lessonPlanOrChangePlan, index);
      print('dzień$index');
    }
  }

  List<List<Color>> _loadCardColorList(int whichDayIsActive) {
    List<List<Color>> cardColorList = [
      [Colors.black26, Colors.indigoAccent],
      [Colors.black26, Colors.indigoAccent],
      [Colors.black26, Colors.indigoAccent],
      [Colors.black26, Colors.indigoAccent],
      [Colors.black26, Colors.indigoAccent],
      [Colors.black26, Colors.indigoAccent],
    ];

    cardColorList.insert(whichDayIsActive, [Colors.indigoAccent, Colors.white]);

    return cardColorList;
  }

  bool activationOrDeactivationDaysAndHoursGestureDetector(
    lessonPlanOrChangePlan,
    List<TextEditingController> controller,
    int whichDayIsActive,
    List<String> currentDayPlan,
  ) {
    if (lessonPlanOrChangePlan == true) {
      return false;
    } else {
      _lessonPlanListForUndoSetNewPlan = currentDayPlan;
      _whichDayIsActiveForUndoSetNewPlan = whichDayIsActive;
      List<String> newPlan = [];
      for (int i = 0; i <= 7; i++) {
        newPlan.add(controller[i].text);
        _setNewPlan(
          newPlan,
          whichDayIsActive,
        );
      }
      print(newPlan);
      return true;
    }
  }

  Future<void> undoSetNewPlan() async {
    if ((_lessonPlanListForUndoSetNewPlan !=
            initialValueOfLessonPlanListForUndoSetNewPlan) &&
        (_whichDayIsActiveForUndoSetNewPlan !=
            initialValueOfWhichDayIsActiveForUndoSetNewPlan)) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(
          lessonPlanKeys[_whichDayIsActiveForUndoSetNewPlan],
          _lessonPlanListForUndoSetNewPlan);
    }
  }

  Future<void> _setNewPlan(
    List<String> newPlan,
    int whichDayIsActive,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(lessonPlanKeys[whichDayIsActive], newPlan);
  }
}

const List<String> lessonPlanKeys = [
  'monday',
  'tuesday',
  'wednesday',
  'thursday',
  'friday',
];

const List<String> defaultLessonPlan = [
  'a',
  'b',
  'c',
  'd',
  'e',
  'f',
  'g',
  'h',
];

const List<TimeOfDay> lessonHours = [
  TimeOfDay(hour: 8, minute: 0),
  TimeOfDay(hour: 8, minute: 45),
  TimeOfDay(hour: 8, minute: 55),
  TimeOfDay(hour: 9, minute: 40),
  TimeOfDay(hour: 9, minute: 50),
  TimeOfDay(hour: 10, minute: 35),
  TimeOfDay(hour: 10, minute: 45),
  TimeOfDay(hour: 11, minute: 30),
  TimeOfDay(hour: 11, minute: 45),
  TimeOfDay(hour: 12, minute: 30),
  TimeOfDay(hour: 12, minute: 45),
  TimeOfDay(hour: 13, minute: 30),
  TimeOfDay(hour: 13, minute: 40),
  TimeOfDay(hour: 14, minute: 25),
  TimeOfDay(hour: 14, minute: 35),
  TimeOfDay(hour: 15, minute: 20),
  TimeOfDay(hour: 15, minute: 50),
];

const bool initialValueFirstParameter = true;

const int initialValueSecondParameter = 5;

const int initialValueOfWhichDayIsActiveForUndoSetNewPlan = 100;

const List<String> initialValueOfLessonPlanListForUndoSetNewPlan = [];
